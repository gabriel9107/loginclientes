import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/clases/pedidos.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/modelos/resumen.dart';

class PedidoServicio extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<Pedido> pedidos = [];
  final int pedidosSincronizados = 0;
  final int pedidoSubido = 0;

  PedidoServicio() {
    downloadOrdes();
    uploadOrdes();
  }

  Future downloadOrdes() async {
    var client = http.Client();
    try {
      var response = await client.get(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/Pedidos.json'),
          headers: {"Content-Type": "application/json"});

      final Map<String, dynamic> ordersMap = json.decode(response.body);

      ordersMap.forEach((key, value) {
        final tempOrders = Pedido.fromMap(value);
        pedidos.add(tempOrders);
      });

      pedidos.forEach((pedido) {
        DatabaseHelper.instance.AgregarPedidoNoDescargado(pedido).then((value) {
          pedidosSincronizados + 1;
        });
      });
      Resumen.resumentList.add(Resumen(
          accion: 'Pedidos Descargados',
          cantidad: pedidosSincronizados.toString()));
    } finally {
      client.close();
    }
  }

  Future uploadOrdes() async {
    var pedidosPendiente =
        await DatabaseHelper.instance.obtenerPedidosPendienteDeSincornizacion();

    var client = http.Client();
    try {
      pedidosPendiente.forEach((element) async {
        var response = await client.post(
            Uri.parse(
                'https://siga-d5296-default-rtdb.firebaseio.com/Pedidos.json'),
            body: json.encode(element.toMap()));
        var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        final codeData = json.decode(response.body);
        final decodeData = codeData['name'];

        if (Response.isNotEmpty) {
          DatabaseHelper.instance
              .actualizarPedidoCargado(element.id as int, decodeData);

          DatabaseHelper.instance
              .obtenerPedidoDetalleEspecificoASincronizar(element.id as int)
              .then((value) => {uploadDetallePedido(value, decodeData)});
        }
      });
    } finally {}
    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos      ', cantidad: pedidosPendiente.length.toString()));
  }

  // Future sincronizar() async {
  //   final url = Uri.https(_baseUrl, 'Pedidos.json');
  //   final resp = await http.get(url);
  //   final Map<String, dynamic> map = json.decode(resp.body);
  //   map.forEach((key, value) {
  //     final temp = Pedido.fromMap(value);
  //     temp.idfirebase = key;

  //     this.pedidos.add(temp);
  //   });

  //   pedidos.forEach((pedido) {
  //     DatabaseHelper.instance.AgregarPedidoNoDescargado(pedido).then((value) {
  //       if (value == 1) {
  //         pedidosSincronizados + 1;
  //         buscarDetalleaSincronizar(pedido);
  //       }
  //     });
  //   });
  //   Resumen.resumentList.add(Resumen(
  //       accion: 'Pedidos Descargados',
  //       cantidad: pedidosSincronizados.toString()));
  // }

  // Future cargarPedidos() async {
  //   var clientes = await DatabaseHelper.instance
  //       .obtenerPedidosPendienteDeSincornizacion()
  //       .then((value) => sincronizaClienteFire(value));
  // }

  // sincronizaClienteFire(List<Pedido> pedidos) async {
  //   final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  //   final url = Uri.https(_baseUrl, 'Pedidos.json');

  //   pedidos.forEach((pedido) async {
  //     final resp = await http.post(url, body: json.encode(pedido.toJsonUp()));
  //     final codeData = json.decode(resp.body);
  //     final decodeData = codeData['name'];
  //     if (decodeData.isNotEmpty) {
  //       DatabaseHelper.instance
  //           .actualizarPedidoCargado(pedido.id as int, decodeData);

  //       DatabaseHelper.instance
  //           .obtenerPedidoDetalleEspecificoASincronizar(pedido.id as int)
  //           .then((value) => {sincronizarDetallePedido(value, decodeData)});
  //     }
  //   });

  //   Resumen.resumentList.add(Resumen(
  //       accion: 'Pedidos Cargados', cantidad: pedidos.length.toString()));
  // }

  uploadDetallePedido(List<PedidoDetalle> pedidoDetalle, String decode) async {
    pedidoDetalle.forEach((element) async {
      element.idfirebase = decode;
      final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
      final resp = await http.post(url, body: element.toJson());

      final decodeData = resp.body;

      print(decodeData);

      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPedidoDetalleCargado(element.id as int, decodeData);
      }
      Resumen.resumentList.add(Resumen(
          accion: 'Pedidos Detalle Cargado',
          cantidad: pedidoSubido.toString()));
    });
    // var client = http.Client();

    // try {
    //   pedidoDetalle.forEach((element) async {
    //     var response = await client.post(
    //         Uri.parse(
    //             'https://siga-d5296-default-rtdb.firebaseio.com/PedidoDetalle.json'),
    //         body: json.encode(element.toMap()));
    //     var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //     final codeData = json.decode(response.body);
    //     final decodeData = codeData['name'];
    //     DatabaseHelper.instance
    //         .actualizarPedidoDetalleCargado(element.id as int, decodeData);
    //   });
    //   Resumen.resumentList.add(Resumen(
    //       accion: 'Pedidos Detalle Cargado',
    //       cantidad: pedidoSubido.toString()));
    // } finally {
    //   client.close();
    // }
  }

  // sincronizarDetallePedido(
  //     List<PedidoDetalle> pedidoLista, String decode) async {
  //   pedidoLista.forEach((element) async {
  //     element.idfirebase = decode;
  //     final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
  //     final resp = await http.post(url, body: element.toJson());

  //     final decodeData = resp.body;

  //     print(decodeData);

  //     if (decodeData.isNotEmpty) {
  //       DatabaseHelper.instance
  //           .actualizarPedidoDetalleCargado(element.id as int, decodeData);
  //     }
  //     Resumen.resumentList.add(Resumen(
  //         accion: 'Pedidos Detalle Cargado',
  //         cantidad: pedidoSubido.toString()));
  //   });
  // }

  void buscarDetalleaSincronizar(Pedido pedido) async {
    var detalle = DatabaseHelper.instance
        .obtenerDetallePedidosPendienteDeSincornizacion();
  }
}

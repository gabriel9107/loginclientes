import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/pedidoDetalle.dart';

import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/modelos/resumen.dart';

class PedidoDetalleServicio extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<PedidoDetalle> detalle = [];
  final int bajado = 0;

  PedidoDetalleServicio() {
    downloadOrderDetalls();
    // cargarDetallePedidos();
  }
  Future downloadOrderDetalls() async {
    var client = http.Client();
    int bajado = 0;
    try {
      var response = await client.get(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/PedidoDetalle.json'),
          headers: {"Content-Type": "application/json"});

      final Map<String, dynamic> ordersDetallsMap = json.decode(response.body);

      ordersDetallsMap.forEach((key, value) {
        final tempOrders = PedidoDetalle.fromMap(value);
        detalle.add(tempOrders);
      });

      detalle.forEach((pedido) {
        DatabaseHelper.instance
            .AgregarPedidoDetalleNoDescargado(pedido)
            .then((value) => {bajado + 1});
      });
      Resumen.resumentList.add(Resumen(
          accion: 'Pedidos Detalle  Descargados', cantidad: bajado.toString()));
    } finally {
      client.close();
    }
  }

  // Future sincronizar() async {
  //   final url = Uri.https(_baseUrl, 'PedidoDetalle.json');

  //   final resp = await http.get(url);

  //   final Map<String, dynamic> map = json.decode(resp.body);
  //   map.forEach((key, value) {
  //     final temp = PedidoDetalle.fromMapFire(value);
  //     temp.idfirebase = key;
  //     this.detalle.add(temp);
  //   });

  //   detalle.forEach((pedido) {
  //     DatabaseHelper.instance
  //         .AgregarPedidoDetalleNoDescargado(pedido)
  //         .then((value) => {
  //               if (value == 0) {bajado + 1} else {}
  //             });
  //   });

  //   Resumen.resumentList.add(Resumen(
  //       accion: 'Pedidos Detalle Descargado', cantidad: bajado.toString()));
  // }

  Future cargarDetallePedidos() async {
    print('este es un reporte');
    var clientes = await DatabaseHelper.instance
        .obtenerDetallePedidosPendienteDeSincornizacion()
        .then((value) => sincronizaClienteFire(value));
  }

  sincronizaClienteFire(List<PedidoDetalle> pedidoLista) async {
    pedidoLista.forEach((element) async {
      final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
      final resp = await http.post(url, body: element.toJson());

      final decodeData = resp.body;

      print(decodeData);

      if (decodeData.isNotEmpty) {
        // DatabaseHelper.instance
        //     .actualizarPedidoDetalleCargado(element.id as int, decodeData);
      }
      Resumen.resumentList.add(Resumen(
          accion: 'Pedidos Detalle Cargado',
          cantidad: pedidoLista.length.toString()));
    });
  }
}

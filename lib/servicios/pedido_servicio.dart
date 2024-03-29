import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
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

  PedidoServicio() {
    // sincronizar();
    cargarPedidos();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pedidos.json');

    final resp = await http.get(url);

    final Map<String, dynamic> map = json.decode(resp.body);
    map.forEach((key, value) {
      final temp = Pedido.fromMap(value);
      temp.idfirebase = key;

      this.pedidos.add(temp);
    });

    print(this.pedidos[0].clienteId);
    pedidos.forEach((pedido) {
      DatabaseHelper.instance.AgregarPedidoNoDescargado(pedido).then((value) {
        if (value == 1) {
          pedidosSincronizados + 1;
        }
      });
    });
    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Sincronizados',
        cantidad: pedidosSincronizados.toString()));
  }

  Future cargarPedidos() async {
    var clientes = await DatabaseHelper.instance
        .obtenerPedidosPendienteDeSincornizacion()
        .then((value) => sincronizaClienteFire(value));
  }

  sincronizaClienteFire(List<Pedido> pedidos) async {
    final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
    final url = Uri.https(_baseUrl, 'Pedidos.json');

    pedidos.forEach((pedido) async {
      final resp = await http.post(url, body: json.encode(pedido.toJsonUp()));
      final codeData = json.decode(resp.body);
      final decodeData = codeData['name'];
      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPedidoCargado(pedido.id as int, decodeData);

        DatabaseHelper.instance
            .obtenerPedidoDetalleEspecificoASincronizar(pedido.id as int)
            .then((value) => {sincronizarDetallePedido(value, decodeData)});
      }
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Subidos', cantidad: pedidos.length.toString()));
  }

  sincronizarDetallePedido(
      List<PedidoDetalle> pedidoLista, String decode) async {
    pedidoLista.forEach((element) async {
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
          cantidad: pedidoLista.length.toString()));
    });
  }
}

import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/servicios/db_helper.dart';

class PedidoDetalleServicio extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<PedidoDetalle> detalle = [];

  PedidoDetalleServicio() {
    this.sincronizar();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'PedidoDetalle.json');

    final resp = await http.get(url);

    final Map<String, dynamic> map = json.decode(resp.body);
    map.forEach((key, value) {
      final temp = PedidoDetalle.fromMap(value);
      this.detalle.add(temp);
    });

    print(this.detalle[0].pedidoId);
    detalle.forEach((pedido) {
      DatabaseHelper.instance.AgregarPedidoDetalle(pedido);
    });
  }
}

import 'package:flutter/foundation.dart';
import 'package:sigalogin/clases/pedidos.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/servicios/db_helper.dart';

class PedidoServicio extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Pedido> pedidos = [];

  PedidoServicio() {
    this.sincronizar();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pedidos.json');

    final resp = await http.get(url);

    final Map<String, dynamic> map = json.decode(resp.body);
    map.forEach((key, value) {
      final temp = Pedido.fromMap(value);
      this.pedidos.add(temp);
    });

    print(this.pedidos[0].clienteId);
    pedidos.forEach((pedido) {
      DatabaseHelper.instance.AgregarPedido(pedido);
    });
  }
}

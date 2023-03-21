import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/ordenDePago.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import '../clases/modelos/clientes.dart';
import '../clases/modelos/productos.dart';

class OrdenDepagoServicio extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';

  OrdenDepagoServicio() {
    this.sincronizar();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pagos.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    // DatabaseHelper.instance.Deleteproducto();
    final Map<String, dynamic> servicioMap = json.decode(response.body);
    // final productomap = Producto.fromJson(productosMap);

    servicioMap.forEach((key, value) {
      // if (value != "") {
      final pago = Pago.fromJson(value);

      // DatabaseHelper.instance.aregarPago(pago);
    });
  }
}

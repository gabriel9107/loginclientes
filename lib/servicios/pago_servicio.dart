import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/pago.dart';

import '../clases/modelos/resumen.dart';
import 'db_helper.dart';

class PagoServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Pago> pagos = [];

  PagoServices() {
    this.sincronizar();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pagos.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    // DatabaseHelper.instance.Deleteproducto();
    final Map<String, dynamic> map = json.decode(response.body);

    map.forEach((key, value) {
      final temp = Pago.fromMap(value);
      pagos.add(temp);
    });
    print('sincronizando un pago');

    print(pagos[0].clienteId);
//agregando las facturas a la base de datos

    pagos.forEach((pago) {
      DatabaseHelper.instance.agregarPago(pago);
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Pagos Sincronizados', cantidad: pagos.length.toString()));
  }
}

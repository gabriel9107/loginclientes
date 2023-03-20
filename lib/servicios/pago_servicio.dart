import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/modelos/pagodetalle.dart';

import '../clases/modelos/resumen.dart';
import 'db_helper.dart';

class PagoServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Pago> pagos = [];

  PagoServices() {
    cargarPago();
    // this.sincronizar();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pago.json');

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

  Future cargarPago() async {
    print('sincronizando clientes');
    var clientes = await DatabaseHelper.instance
        .obtenerPagosASincornizar()
        .then((value) => sincronizarFire(value));

    DatabaseHelper.instance
        .obtenerPagoDetallessASincornizar()
        .then((value) => sincronizarDetalle(value));
  }

  sincronizarDetalle(List<PagoDetalle> pago) async {
    final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
    final url = Uri.https(_baseUrl, 'PagoDetalle.json');
    pago.forEach((element) async {
      final resp = await http.post(url, body: json.encode(element.toJson()));
      final decodeData = resp.body;
      print(decodeData);
      if (decodeData.isNotEmpty) {
        // DatabaseHelper.instance.actualizarClientesCargado(element.id as int);
      }
    });
  }

  sincronizarFire(List<Pago> pago) async {
    final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
    final url = Uri.https(_baseUrl, 'Pago.json');
    pago.forEach((element) async {
      final resp = await http.post(url, body: json.encode(element.toJson()));
      final decodeData = resp.body;
      print(decodeData);
      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance.actualizarPagoCargado(element.id as int);
      }
    });
  }
}

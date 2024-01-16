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
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<Pago> pagos = [];

  PagoServices() {
    this.cargarPago();
    this.sincronizar();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pago.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    // DatabaseHelper.instance.Deleteproducto();
    if (response != "Null") {
      final Map<String, dynamic> map = json.decode(response.body);

      map.forEach((key, value) {
        final temp = Pago.fromMapInsert(value);
        temp.idFirebase = key;
        pagos.add(temp);
      });

      pagos.forEach((pago) {
        DatabaseHelper.instance.AgregarPagoDescargado(pago);
      });
    }

    Resumen.resumentList.add(Resumen(
        accion: 'Pagos Descargados', cantidad: pagos.length.toString()));
  }

  Future cargarPago() async {
    await DatabaseHelper.instance
        .obtenerPagosASincornizar()
        .then((value) => sincronizarFire(value));

    // DatabaseHelper.instance
    //     .obtenerPagoDetallessASincornizar()
    //     .then((value) => sincronizarDetalle(value));
  }

  sincronizarFire(List<Pago> pago) async {
    final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
    final url = Uri.https(_baseUrl, 'Pago.json');
    pago.forEach((element) async {
      final resp = await http.post(url, body: json.encode(element.toJson()));
      final codeData = json.decode(resp.body);
      final decodeData = codeData['name'];
      print(decodeData);
      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPagoCargado(element.id as int, decodeData)
            .then((value) => {
                  DatabaseHelper.instance
                      .obtenerPagoDetallessASincornizarPorId(element.id as int)
                      .then((value) => {sincronizarDetalle(value, decodeData)})
                });
      }
    });
    Resumen.resumentList.add(
        Resumen(accion: 'Pagos Cargados', cantidad: pagos.length.toString()));
  }

  sincronizarDetalle(List<PagoDetalle> pago, String _pagoIdFirebase) async {
    final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
    final url = Uri.https(_baseUrl, 'PagoDetalle.json');
    pago.forEach((element) async {
      element.pagoIdFirebase = _pagoIdFirebase;
      final resp = await http.post(url, body: json.encode(element.toJson()));
      final decodeData = resp.body;

      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPagoCargado(element.id as int, decodeData);
      }
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Pago Detalle Cargado', cantidad: pagos.length.toString()));
  }
}

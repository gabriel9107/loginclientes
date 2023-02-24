import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/detalleFactura.dart';

class FacturaDetalleServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<FacturaDetalle> detalles = [];

  FacturaDetalleServices() {
    this.cargarDetalleFacturas();
  }

  Future cargarDetalleFacturas() async {
    final url = Uri.https(_baseUrl, 'FacturaDetalles.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    // DatabaseHelper.instance.Deleteproducto();
    final Map<String, dynamic> map = json.decode(resp.body);

    map.forEach((key, value) {
      final temp = FacturaDetalle.fromMap(value);
      detalles.add(temp);
    });

    detalles.forEach((element) {
      DatabaseHelper.instance.SincronizarDefalleFactura(element);
    });
    // print(detalles[0].facturaId.toString());
    // final facturamap = Factura.fromJson(facturaMap);

    // facturaMap.forEach((key, value) {
    //   // if (value != "") {
    //   final temp = FacturaDetalleAsync.fromJson(value);

    //   FacturaDetalleAsync detalleAsync = FacturaDetalleAsync(
    //       facturaNumero: temp.facturaNumero,
    //       lineaNumero: temp.lineaNumero,
    //       nombre: temp.nombre,
    //       precioDeventa: temp.precioDeventa,
    //       productoCodigo: temp.productoCodigo,
    //       qty: temp.qty,
    //       montoLinea: temp.montoLinea);

    //   DatabaseHelper.instance.SincronizarDefalleFactura(detalleAsync);
    // });
  }
}

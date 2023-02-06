import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/factura.dart';

import '../clases/detalleFactura.dart';
import 'db_helper.dart';

class FacturaDetalleServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<FacturaDetalleAsync> facturas = [];

  FacturaDetalleServices() {
    this.cargarDetalleFacturas();
  }

  Future cargarDetalleFacturas() async {
    final url = Uri.https(_baseUrl, 'FacturaDetalle.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    final Map<String, dynamic> facturaMap = json.decode(response.body);
    final facturamap = Factura.fromJson(facturaMap);

    facturaMap.forEach((key, value) {
      // if (value != "") {
      final temp = FacturaDetalleAsync.fromJson(value);

      FacturaDetalleAsync detalleAsync = FacturaDetalleAsync(
          facturaNumero: temp.facturaNumero,
          lineaNumero: temp.lineaNumero,
          nombre: temp.nombre,
          precioDeventa: temp.precioDeventa,
          productoCodigo: temp.productoCodigo,
          qty: temp.qty,
          montoLinea: temp.montoLinea);

      DatabaseHelper.instance.SincronizarDefalleFactura(detalleAsync);
    });
  }
}

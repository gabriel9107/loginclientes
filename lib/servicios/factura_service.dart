import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/factura.dart';

import 'db_helper.dart';

class FacturaServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Factura> facturas = [];

  FacturaServices() {
    this.cargarFacturas();
  }

  Future cargarFacturas() async {
    final url = Uri.https(_baseUrl, 'Factura.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    // DatabaseHelper.instance.Deleteproducto();
    final Map<String, dynamic> productosMap = json.decode(response.body);
    final productomap = Factura.fromJson(productosMap);

    productosMap.forEach((key, value) {
      if (value != "") {
        final temp = Factura.fromJson(value);

        Factura facturas = Factura(
            id: temp.id,
            clienteId: temp.clienteId,
            facturaFecha: temp.facturaFecha,
            facturaId: temp.facturaId,
            facturaVencimiento: temp.facturaVencimiento,
            metodoDePago: temp.metodoDePago,
            montoFactura: temp.montoFactura,
            pedidosId: temp.pedidosId,
            totalPagado: temp.totalPagado);

        DatabaseHelper.instance.SincronizarFactura(facturas);
      }
    });
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/detalleFactura.dart';
import '../clases/modelos/resumen.dart';

class FacturaDetalleServices extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<FacturaDetalle> detalles = [];

  FacturaDetalleServices() {
    downloadInvoiceDetails();
  }

  Future downloadInvoiceDetails() async {
    int cantidad = 0;
    var client = http.Client();
    try {
      var response = await client.get(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/FacturaDetalle.json'),
          headers: {"Content-Type": "application/json"});

      final Map<String, dynamic> facturaMap = json.decode(response.body);

      facturaMap.forEach((key, value) {
        final temp = FacturaDetalle.fromMap(value);
        detalles.add(temp);
      });
      print('Usuario sincronizadas');
      detalles.forEach((element) async {
        await DatabaseHelper.instance.SincronizarDefalleFactura(element);
        cantidad += 1;
      });

      Resumen.resumentList.add(Resumen(
          accion: 'Facturas Detalle Sincronizados',
          cantidad: detalles.length.toString()));
    } finally {
      client.close();
    }
  }

  Future cargarDetalleFacturas() async {
    int cantidad = 0;
    final url = Uri.https(_baseUrl, 'FacturaDetalle.json');

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
    print('Usuario sincronizadas');
    detalles.forEach((element) async {
      await DatabaseHelper.instance.SincronizarDefalleFactura(element);
      cantidad += 1;
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Facturas Detalle Sincronizados',
        cantidad: detalles.length.toString()));
  }
}

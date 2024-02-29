import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/global.dart';

import '../clases/modelos/resumen.dart';
import 'db_helper.dart';

class FacturaServices extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<Factura> facturas = [];
  int fin = 0;

  bool foreEachDone = false;

  FacturaServices() {
    this.downloadInvoices();
  }

  Future downloadInvoices() async {
    var client = http.Client();
    try {
      var response = await client.get(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/Factura.json'),
          headers: {"Content-Type": "application/json"});

      final Map<String, dynamic> clienteMap = json.decode(response.body);

      clienteMap.forEach((key, value) {
        final tempInvoice = Factura.fromMap(value);
        this.facturas.add(tempInvoice);
      });

      facturas.forEach((factura) async {
        await DatabaseHelper.instance.SincronizarFactura(factura);
        fin += 1;
      });

      if (fin == facturas.length) estado += 1;

      print('Facturas Sincronizados');

      Resumen.resumentList.add(Resumen(
          accion: 'Facturas Sincronizados',
          cantidad: facturas.length.toString()));
    } finally {
      client.close();
    }
  }

//   Future descargarFacturas() async {
//     final url = Uri.https(_baseUrl, 'Factura.json');

//     final resp = await http.get(url);

//     final response =
//         await http.get(url, headers: {"Content-Type": "application/json"});
//     // final jsonList = jsonDecode(response.body) as List<dynamic>;

//     // DatabaseHelper.instance.Deleteproducto();
//     final Map<String, dynamic> map = json.decode(response.body);

//     map.forEach((key, value) {
//       final temp = Factura.fromMap(value);
//       facturas.add(temp);
//     });

// //agregando las facturas a la base de datos

//     facturas.forEach((factura) {
//       DatabaseHelper.instance.SincronizarFactura(factura);
//     });

//     print('Facturas sincronizadas');
//     Resumen.resumentList.add(Resumen(
//         accion: 'Facturas Sincronizados',
//         cantidad: facturas.length.toString()));
//     // if (value != "") {
//     //   final temp = Factura.fromJson(value);

//     //   Factura facturas = Factura(
//     //       id: temp.id,
//     //       clienteId: temp.clienteId,
//     //       facturaFecha: temp.facturaFecha,
//     //       facturaId: temp.facturaId,
//     //       facturaVencimiento: temp.facturaVencimiento,
//     //       metodoDePago: temp.metodoDePago,
//     //       montoFactura: temp.montoFactura,
//     //       pedidosId: temp.pedidosId,
//     //       totalPagado: temp.totalPagado);

//     //   DatabaseHelper.instance.SincronizarFactura(facturas);
//     // }
//     // });
//   }
}

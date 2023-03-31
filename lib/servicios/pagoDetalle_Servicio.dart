// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'package:sigalogin/clases/factura.dart';
// import 'package:sigalogin/clases/modelos/pago.dart';
// import 'package:sigalogin/clases/modelos/pagodetalle.dart';

// import '../clases/modelos/resumen.dart';
// import 'db_helper.dart';

// class PagodetalleServicio extends ChangeNotifier {
//   final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
//   final List<PagoDetalle> pagos = [];

//   PagodetalleServicio() {
//     this.cargarPago();
//   }

//   Future cargarPago() async {
//     var clientes = await DatabaseHelper.instance
//         .obtenerPagoDetallessASincornizar()
//         .then((value) => sincronizarFire(value));
//   }

//   sincronizarFire(List<PagoDetalle> pago, String _pagoIdFirebase) async {
//     final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
//     final url = Uri.https(_baseUrl, 'PagoDetalle.json');
//     pago.forEach((element) async {
//       element.pagoIdFirebase = _pagoIdFirebase;
//       final resp = await http.post(url, body: json.encode(element.toJson()));
//       final decodeData = resp.body;

//       if (decodeData.isNotEmpty) {
//         DatabaseHelper.instance
//             .actualizarPagoCargado(element.id as int, decodeData);
//       }
//     });
//   }
// }

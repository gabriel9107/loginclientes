import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/pantallas/pedidos/pedidos.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/modelos/resumen.dart';

class PedidoDetalleServicio extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<PedidoDetalle> detalle = [];
  final int bajado = 0;

  PedidoDetalleServicio() {
//    this.sincronizar();
    cargarDetallePedidos();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'PedidoDetalle.json');

    final resp = await http.get(url);

    final Map<String, dynamic> map = json.decode(resp.body);
    map.forEach((key, value) {
      final temp = PedidoDetalle.fromMapFire(value);
      temp.idfirebase = key;
      this.detalle.add(temp);
    });

    detalle.forEach((pedido) {
      DatabaseHelper.instance
          .AgregarPedidoDetalleNoDescargado(pedido)
          .then((value) => {
                if (value == 0) {bajado + 1} else {}
              });
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Detalle Descargado', cantidad: bajado.toString()));
  }

  Future cargarDetallePedidos() async {
    print('este es un reporte');
    var clientes = await DatabaseHelper.instance
        .obtenerDetallePedidosPendienteDeSincornizacion()
        .then((value) => sincronizaClienteFire(value));
  }

  sincronizaClienteFire(List<PedidoDetalle> pedidoLista) async {
    pedidoLista.forEach((element) async {
      final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
      final resp = await http.post(url, body: element.toJson());

      final decodeData = resp.body;

      print(decodeData);

      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPedidoDetalleCargado(element.id as int, decodeData);
      }
      Resumen.resumentList.add(Resumen(
          accion: 'Pedidos Detalle Cargado',
          cantidad: pedidoLista.length.toString()));
    });

    // // DatabaseReference ref = FirebaseDatabase.instance.ref('Clientes/123');
    // // CollectionReference users =
    // //     FirebaseFirestore.instance.collection('Pedidos');
    // final databaseReference = FirebaseDatabase.instance.ref('PedidoDetalle');

    // pedidoLista.forEach((element) async {
    //   await databaseReference.child(element.id.toString()).set({
    //     "Cantidad": element.cantidad,
    //     "Compagnia": element.compagnia,
    //     "Id": element.id,
    //     "IsDelete": element.isDelete,
    //     "PedidoId": element.pedidoId,
    //     "Precio": element.precio,
    //     "ProductoId": element.productoId,
    //     "Sincronizado": element.sincronizado,
    //     "Codigo": element.codigo,
    //     "Nombre": element.nombre,
    //   });

    // Resumen.resumentList.add(Resumen(
    //     accion: 'Pedidos Subidos', cantidad: pedidoLista.length.toString()));
  }
}

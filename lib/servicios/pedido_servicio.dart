import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:sigalogin/clases/pedidos.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/modelos/resumen.dart';

class PedidoServicio extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Pedido> pedidos = [];

  PedidoServicio() {
    // sincronizar();
    cargarPedidos();
  }

  Future sincronizar() async {
    final url = Uri.https(_baseUrl, 'Pedidos.json');

    final resp = await http.get(url);

    final Map<String, dynamic> map = json.decode(resp.body);
    map.forEach((key, value) {
      final temp = Pedido.fromMap(value);
      this.pedidos.add(temp);
    });

    print(this.pedidos[0].clienteId);
    pedidos.forEach((pedido) {
      DatabaseHelper.instance.AgregarPedido(pedido);
    });
    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Sincronizados', cantidad: pedidos.length.toString()));
    // print(this.clientes[0].nombre);
    //
  }

  Future cargarPedidos() async {
    print('este es un reporte');
    var clientes = await DatabaseHelper.instance
        .obtenerPedidosPendienteDeSincornizacion()
        .then((value) => sincronizaClienteFire(value));
  }

  sincronizaClienteFire(List<Pedido> pedidoLista) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref('Clientes/123');
    // CollectionReference users =
    //     FirebaseFirestore.instance.collection('Pedidos');
    final databaseReference = FirebaseDatabase.instance.ref('Pedidos');

    pedidoLista.forEach((element) async {
      await databaseReference
          .child(element.id.toString() + element.clienteId.toString())
          .set({
        "ClienteId": element.clienteId,
        "Compagnia": element.compagnia,
        "FechaOrden": element.fechaOrden.toIso8601String(),
        "Id": element.id,
        "Impuestos": element.impuestos,
        "IsDelete": element.isDelete,
        "NumeroOrden": element.numeroOrden,
        "Sincronizado": element.sincronizado,
        "totalAPagar": element.totalAPagar,
        "Estado": element.estado
      });

      DatabaseHelper.instance.actualizarPedidoCargado(element.id as int);
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Subidos', cantidad: pedidoLista.length.toString()));
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/clases/modelos/resumen.dart';
import 'package:sigalogin/pantallas/clientes/listaClientes.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import '../clases/modelos/clientes.dart';

class ClienteSevices extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  late List<Cliente> clientes = [];

  ClienteSevices() {
    uploadClients();
    downloadClients();
  }

  Future downloadClients() async {
    var client = http.Client();
    try {
      var response = await client.get(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/Clientes.json'),
          headers: {"Content-Type": "application/json"});

      final Map<String, dynamic> clienteMap = json.decode(response.body);

      clienteMap.forEach((key, value) {
        final tempClientes = Cliente.fromMap(value);
        this.clientes.add(tempClientes);
      });
      print('Usuario sincronizadas');
      clientes.forEach((cliente) {
        DatabaseHelper.instance.customerExists(cliente);
      });

      Resumen.resumentList.add(Resumen(
          accion: 'Clientes Descargados',
          cantidad: clientes.length.toString()));
    } finally {
      client.close();
    }
  }

// clientes.

  // Future descargarClientes() async {
  //   final url = Uri.https(_baseUrl, 'Clientes.json');

  //   final resp = await http.get(url);

  //   final response =
  //       await http.get(url, headers: {"Content-Type": "application/json"});

  //   final Map<String, dynamic> clienteMap = json.decode(resp.body);

  //   clienteMap.forEach((key, value) {
  //     if (value != null) {
  //       final tempCliente = Cliente.fromMapfromJson(value);

  //       this.clientes.add(tempCliente);
  //     }
  //   });
  //   print('Usuario sincronizadas');
  //   clientes.forEach((cliente) {
  //     DatabaseHelper.instance.customerExists(cliente);
  //   });

  //   Resumen.resumentList.add(Resumen(
  //       accion: 'Clientes Descargados', cantidad: clientes.length.toString()));
  //   // print(this.clientes[0].nombre);
  //   //
  // }

  Future uploadClients() async {
    final url = Uri.https(_baseUrl, 'Usuario.json');
    var clientes = await DatabaseHelper.instance.obtenerClientesNuevos();

    var client = http.Client();
    try {
      clientes.forEach((element) async {
        var response = await client.post(
            Uri.parse(
                'https://siga-d5296-default-rtdb.firebaseio.com/Clientes.json'),
            body: json.encode(element.toMap()));
        var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        if (Response.isNotEmpty) {
          DatabaseHelper.instance.actualizarClientesCargado(element.id as int);
        }
      });
      Resumen.resumentList.add(Resumen(
          accion: 'Usuario     ', cantidad: clientes.length.toString()));
    } finally {
      client.close();
    }
  }

  // Future cargarClientes() async {
  //   print('sincronizando clientes');
  //   var clientes = await DatabaseHelper.instance
  //       .obtenerClientesNuevos()
  //       .then((value) => sincronizaClienteFire(value));
  // }

  // sincronizaClienteFire(List<Cliente> clienteList) async {
  //   final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  //   final url = Uri.https(_baseUrl, 'Clientes.json');
  //   clienteList.forEach((element) async {
  //     final resp = await http.post(url, body: json.encode(element.toJsonUp()));
  //     final decodeData = resp.body;
  //     print(decodeData);
  //     if (decodeData.isNotEmpty) {
  //       DatabaseHelper.instance.actualizarClientesCargado(element.id as int);
  //     }
  //   });
  //   Resumen.resumentList.add(Resumen(
  //       accion: 'Clientes Subidos', cantidad: clienteList.length.toString()));

  //   final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  // final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
  // final resp = await http.post(url, body: detalle.toJson());

  // final decodeData = resp.body;

  // print(decodeData);

  // if (decodeData.isNotEmpty) {
  //   DatabaseHelper.instance.actualizarPedidoCargado(detalle.id as int);
  // }

  // print(clienteList);

  // // DatabaseReference ref = FirebaseDatabase.instance.ref('Clientes/123');
  // CollectionReference users =
  //     FirebaseFirestore.instance.collection('Clientes');
  // final databaseReference = FirebaseDatabase.instance.ref('Clientes');

  // clienteList.forEach((element) async {
  //   await databaseReference.child(element.id.toString()).set({
  //     "ID": element.id,
  //     "activo": element.activo.toString(),
  //     "codigo": element.codigo,
  //     "codigoVendedor": element.codigoVendedor,
  //     "comentario": "n/a",
  //     "compagnia": element.compagnia,
  //     "direccion": element.direccion,
  //     "nombre": element.nombre,
  //     "sincronizado": "1",
  //     "telefono1": element.telefono1,
  //     "telefono2": element.telefono1,
  //   });
  //   DatabaseHelper.instance.actualizarClientesCargado(element.id.toString());
  // });

  // Resumen.resumentList.add(Resumen(
  //     accion: 'Clientes Subidos', cantidad: clienteList.length.toString()));
}

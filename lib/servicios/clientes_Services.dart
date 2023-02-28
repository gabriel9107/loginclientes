import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/clases/modelos/resumen.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import '../clases/modelos/clientes.dart';

class ClienteSevices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Cliente> clientes = [];

  ClienteSevices() {
    this.cargarClientes();
  }

  Future cargarClientes() async {
    final url = Uri.https(_baseUrl, 'Clientes.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> clienteMap = json.decode(resp.body);

    clienteMap.forEach((key, value) {
      if (value != null) {
        final tempCliente = Cliente.fromMap(value);

        this.clientes.add(tempCliente);
      }
    });

    clientes.forEach((cliente) {
      DatabaseHelper.instance.customerExists(cliente);
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Clientes Sincronizados',
        cantidad: clientes.length.toString()));
    // print(this.clientes[0].nombre);
    //
  }
}
      // if (value != "") {
      //   final tempCliente = Cliente.fromJson(value);
      //   tempCliente.codigo = key;

        // var insert = Customers(
        //     CustomerCode: tempCliente.codigo.toString(),
        //     CustomerName: tempCliente.nombre.toString(),
        //     CustomerDir: tempCliente.nombre.toString(),
        //     Phone1: tempCliente.telefono1.toString(),
        //     Phone2: tempCliente.telefono1.toString(),
        //     Comment1: tempCliente.comentario.toString(),
        //     creadoEn: DateTime.now().toString(),
        //     creadoPor: tempCliente.codigoVendedor.toString());
        // DatabaseHelper.instance.customerExists(insert);
    //   }
    // });

    // final Map<String, dynamic> jsonResponse = json.decode(response.body);
    // List jsonResponse = json.decode(response.body);
    // final jsonList = jsonDecode(response.body) as List<dynamic>;
  

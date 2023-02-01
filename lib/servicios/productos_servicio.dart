import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../clases/modelos/clientes.dart';

class ClienteSevices extends ChangeNotifier {
  final String _baseUrl = '';
  final List<Cliente> cliente = [];

  ClienteSevices() {
    this.cargarClientes();
  }

  Future cargarClientes() async {
    final url = Uri.https(_baseUrl, 'Cliente.json');

    final resp = await http.get(url);
    final Map<String, dynamic> clienteMap = json.decode(resp.body);
    print('mapa');
    print(clienteMap);
  }
}

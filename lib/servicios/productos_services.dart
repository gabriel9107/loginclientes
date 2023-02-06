import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import '../clases/modelos/clientes.dart';
import '../clases/modelos/productos.dart';

class ProductoServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Cliente> clientes = [];

  ProductoServices() {
    this.cargarProductos();
  }

  Future cargarProductos() async {
    final url = Uri.https(_baseUrl, 'Productos.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    DatabaseHelper.instance.Deleteproducto();
    final Map<String, dynamic> productosMap = json.decode(response.body);
    final productomap = Producto.fromJson(productosMap);

    productosMap.forEach((key, value) {
      // if (value != "") {
      final tempProductos = Producto.fromJson(value);

      Producto produts = Producto(
          compagnia: tempProductos.compagnia,
          isDelete: tempProductos.isDelete,
          nombre: tempProductos.nombre,
          ouM: tempProductos.ouM,
          price: tempProductos.price,
          productoCodigo: tempProductos.productoCodigo,
          qty: tempProductos.qty,
          sincronizado: tempProductos.sincronizado,
          typeOfSales: tempProductos.typeOfSales);

      DatabaseHelper.instance.productoExists(produts);
      // }

      // DatabaseHelper.instance.aregarProductoSiNoExiste(
      //     tempProductos.productoCodigo.toString(), productomap);
      // tempProductos.id = key.toString();

      // var insert = Customers(
      //     CustomerCode: tempCliente.codigo.toString(),
      //     CustomerName: tempCliente.nombre.toString(),
      //     CustomerDir: tempCliente.nombre.toString(),
      //     Phone1: tempCliente.telefono1.toString(),
      //     Phone2: tempCliente.telefono2.toString(),
      //     Comment1: tempCliente.comentario.toString());
      // DatabaseHelper.instance.Add(insert);
    });
    // final Map<String, dynamic> jsonResponse = json.decode(response.body);
    // List jsonResponse = json.decode(response.body);
    // final jsonList = jsonDecode(response.body) as List<dynamic>;
  }

  SincronizarClientes(var respuesta) {}
}
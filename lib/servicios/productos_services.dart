import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import '../clases/modelos/clientes.dart';
import '../clases/modelos/productos.dart';

class ProductoServices extends ChangeNotifier {
  final String _baseUrl = 'sigaapp-127c4-default-rtdb.firebaseio.com';
  final List<Producto> productos = [];

  ProductoServices() {
    this.cargarProductos();
  }

  Future cargarProductos() async {
    final url = Uri.https(_baseUrl, 'Productos.json');

    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    // final jsonList = jsonDecode(response.body) as List<dynamic>;

    // DatabaseHelper.instance.Deleteproducto();
    final Map<String, dynamic> productosMap = json.decode(resp.body);

    // final productomap = Producto.fromJson(productosMap);

    productosMap.forEach((key, value) {
      final tempProductos = Producto.fromMap(value);
      productos.add(tempProductos);
    });

    DatabaseHelper.instance.eliminarProducto();
    productos.forEach((producto) {
      DatabaseHelper.instance.addProduct(producto);
    });
  }
}

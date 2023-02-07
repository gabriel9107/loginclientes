import 'dart:core';

import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/productos.dart';

import 'customers.dart';

bool ListasFactura = false;
List<Factura> TodasLasFacturas = [];
bool ListaClientes = false;
List<Customers> TodosLosClientes = [];
bool ListaProducto = false;
List<Producto> TodosProductos = [];
List<dynamic> Lista = [];

String CurrentUserName = null.toString();

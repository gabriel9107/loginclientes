import 'dart:core';

import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/productos.dart';

import 'factura.dart';
//compania 1 = Siga, compania 2 = SisaSRl

int compagnia = 1;
String usuario = '';
double _impuesto = 18;
bool ListasFactura = false;
List<Factura> TodasLasFacturas = [];
bool ListaClientes = false;
List<Cliente> TodosLosClientes = [];
bool ListaProducto = false;
List<Producto> TodosProductos = [];
List<dynamic> Lista = [];

String CurrentUserName = null.toString();

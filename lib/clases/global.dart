import 'dart:core';

import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/productos.dart';

import 'factura.dart';

//compania 0 = AX, compania 1 = GP

String compagniaTexto = '';
String nombre_Usuario = '';
int compagnia = 0;
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


// 0 (false) and 1 (true) 
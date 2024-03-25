import 'dart:core';

import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/productos.dart';

import 'factura.dart';

//compania 0 = AX, compania 1 = GP

double procentaje = 0;
int estado = 0;

String compagniaTexto = '';
String nombre_Usuario = '';
int compagnia = 0;
String usuario = '';
String codigoUsuario = '';
double _impuesto = 18;
bool ListasFactura = false;

bool ListaClientes = false;

List<Cliente> TodosLosClientes = [];
bool ListaProducto = false;
List<Producto> TodosProductos = [];
List<dynamic> Lista = [];

String CurrentUserName = null.toString();

//para el listado
bool usuariobool = false;
bool cientesbool = false;
bool productosbool = false;
bool pedidosbool = false;
bool facturabool = false;
bool pagosbool = false;

// 0 (false) and 1 (true)

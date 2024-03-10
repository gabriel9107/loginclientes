// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/detalleFactura.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/modelos/pagodetalle.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/clases/usuario.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
import 'package:sigalogin/pantallas/buscar/buscarProductosEnPedidos.dart';
import 'package:sigalogin/pantallas/pedidos/pedidos.dart';
import 'package:sigalogin/pantallas/productos/products_detail.dart';
import 'package:sigalogin/servicios/UsuarioServicios.dart';
import 'package:sigalogin/servicios/detalleDePago_servicio.dart';
import 'package:sigalogin/servicios/facturaDetalle_servicio.dart';
import 'package:sigalogin/servicios/factura_service.dart';
import 'package:sigalogin/servicios/pagoDetalle_Servicio.dart';
import 'package:sigalogin/servicios/pago_servicio.dart';
import 'package:sigalogin/servicios/pedido_servicio.dart';

import '../../clases/customers.dart';
import '../../clases/modelos/resumen.dart';
import '../../clases/product.dart';
import '../../servicios/clientes_Services.dart';
import '../../servicios/db_helper.dart';
import 'package:provider/provider.dart';

import '../../servicios/PedidoDetalle_Servicio.dart';
import '../../servicios/productos_services.dart';

class PincronizarLista extends StatefulWidget {
  @override
  createState() => PincronizarListState();
}
// State<StatefulWidget> createState() {
//   return ProductsList();
// }

class PincronizarListState extends State<PincronizarLista> {
  bool todobien = false;
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  double contador = 0;
  final List<Pago> pagos = [];
  List<Resumen> resumenDeSincronizacion = [];

  late var timer;

  @override
  void initState() {
    super.initState();
    llamarMetodos();

    resumenDeSincronizacion = [];

    timer = new Timer.periodic(
        Duration(seconds: 70),
        (Timer t) => setState(() {
              resumenDeSincronizacion = Resumen.obtenerResumen();
              if (procentaje >= 80)
                setState(() {
                  todobien = true;
                });
              print('porcentaje');
              print(procentaje);
            }));

    // Timer.periodic(Duration(seconds: 10), (timer) {

    // });
    // resumenDeSincronizacion = Resumen.obtenerResumen();

    // super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // final servicioUsuarios = Provider.of<UsuarioServicios>(context);
    // final servicioProductos = Provider.of<ProductoServices>(context);
    // final servicioClientes = Provider.of<ClienteSevices>(context);

    // final servicioFactura = Provider.of<FacturaServices>(context);
    // final servicioDetalleFactura = Provider.of<FacturaDetalleServices>(context);
    // final servicioPedido = Provider.of<PedidoServicio>(context);
    // final servicioPedidosDetalle = Provider.of<PedidoDetalleServicio>(context);
    // final servicioPago = Provider.of<PagoServices>(context);

    // DBProvider().initializeDB();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Siga Mobile - Detalle de Sincronizacion'),
          backgroundColor: const Color.fromARGB(255, 61, 64, 238),
        ),
        drawer: navegacions(),
        body: todobien == true
            ? Center(
                child: ListView.builder(
                    itemCount: resumenDeSincronizacion.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check),
                          ),
                          title: Text(
                              resumenDeSincronizacion[index].accion.toString()),
                          // subtitle: Text('producto.nombre.toString()'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Cantidad :  '),
                              Text(resumenDeSincronizacion[index]
                                  .cantidad
                                  .toString())
                            ],
                          ),
                          onTap: () {
                            // NavigateDetail('Edit Product');
                          },
                        ),
                      );
                    }))
            : Center(
                child: CircularProgressIndicator(
                  // value: procentaje as double,
                  color: darkBlueColor,
                  strokeWidth: 6,
                ),
              ));
  }

  sincronizarDetalle(List<PagoDetalle> pago, String _pagoIdFirebase) async {
    final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
    final url = Uri.https(_baseUrl, 'PagoDetalle.json');
    pago.forEach((element) async {
      element.pagoIdFirebase = _pagoIdFirebase;
      final resp = await http.post(url, body: json.encode(element.toJson()));
      final decodeData = resp.body;

      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPagoCargado(element.id as int, decodeData);
      }
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Pago Detalle Cargado', cantidad: pagos.length.toString()));
  }
}

downloadPayment() async {
  final List<Pago> pagos = [];
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse('https://siga-d5296-default-rtdb.firebaseio.com/Pago.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> pagoMap = json.decode(response.body);

    if (response != "Null") {
      final Map<String, dynamic> map = json.decode(response.body);

      map.forEach((key, value) {
        final temp = Pago.fromMapInsert(value);
        temp.idFirebase = key;
        pagos.add(temp);
      });
      pagos.forEach((pago) {
        DatabaseHelper.instance.AgregarPagoDescargado(pago);
      });
      Resumen.resumentList.add(Resumen(
          accion: 'Pagos Descargados', cantidad: pagos.length.toString()));
    }
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

Future downloadOrdes() async {
  int pedidosSincronizados = 0;
  final List<Pedido> pedidos = [];
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/Pedidos.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> ordersMap = json.decode(response.body);

    ordersMap.forEach((key, value) {
      final tempOrders = Pedido.fromMap(value);
      pedidos.add(tempOrders);
    });

    pedidos.forEach((pedido) {
      DatabaseHelper.instance.AgregarPedidoNoDescargado(pedido).then((value) {
        pedidosSincronizados + 1;
      });
    });
    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Descargados',
        cantidad: pedidosSincronizados.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

Future downloadOrderDetalls() async {
  final List<PedidoDetalle> detalle = [];
  var client = http.Client();
  int bajado = 0;
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/PedidoDetalle.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> ordersDetallsMap = json.decode(response.body);

    ordersDetallsMap.forEach((key, value) {
      final tempOrders = PedidoDetalle.fromMap(value);
      detalle.add(tempOrders);
    });

    detalle.forEach((pedido) {
      DatabaseHelper.instance
          .AgregarPedidoDetalleNoDescargado(pedido)
          .then((value) => {bajado + 1});
    });
    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Detalle  Descargados', cantidad: bajado.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

Future uploadOrdes() async {
  var pedidosPendiente =
      await DatabaseHelper.instance.obtenerPedidosPendienteDeSincornizacion();

  var client = http.Client();
  try {
    pedidosPendiente.forEach((element) async {
      var response = await client.post(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/Pedidos.json'),
          body: json.encode(element.toMap()));
      var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final codeData = json.decode(response.body);
      final decodeData = codeData['name'];

      if (Response.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPedidoCargado(element.id as int, decodeData);

        DatabaseHelper.instance
            .obtenerPedidoDetalleEspecificoASincronizar(element.id as int)
            .then((value) => {uploadDetallePedido(value, decodeData)});
      }
    });
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
  Resumen.resumentList.add(Resumen(
      accion: 'Pedidos      ', cantidad: pedidosPendiente.length.toString()));
}

uploadDetallePedido(List<PedidoDetalle> pedidoDetalle, String decode) async {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final int pedidoSubido = 0;
  pedidoDetalle.forEach((element) async {
    element.idfirebase = decode;
    final url = Uri.https(_baseUrl, 'PedidoDetalle.json');
    final resp = await http.post(url, body: element.toJson());

    final decodeData = resp.body;

    print(decodeData);

    if (decodeData.isNotEmpty) {
      DatabaseHelper.instance
          .actualizarPedidoDetalleCargado(element.id as int, decodeData);
    }
    Resumen.resumentList.add(Resumen(
        accion: 'Pedidos Detalle Cargado', cantidad: pedidoSubido.toString()));
  });
}

Future downloadInvoiceDetails() async {
  final List<FacturaDetalle> detalles = [];
  int cantidad = 0;
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/FacturaDetalle.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> facturaMap = json.decode(response.body);

    facturaMap.forEach((key, value) {
      final temp = FacturaDetalle.fromMap(value);
      detalles.add(temp);
    });
    print('Usuario sincronizadas');
    detalles.forEach((element) async {
      await DatabaseHelper.instance.SincronizarDefalleFactura(element);
      cantidad += 1;
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Facturas Detalle Sincronizados',
        cantidad: detalles.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

Future downproductos() async {
  final List<Producto> productos = [];
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/Productos.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> productosMap = json.decode(response.body);
    productosMap.forEach((key, value) {
      final tempProductos = Producto.fromMap(value);
      productos.add(tempProductos);
    });

    DatabaseHelper.instance.eliminarProducto();
    productos.forEach((producto) async {
      DatabaseHelper.instance.addProduct(producto);
    });
    print('Productos sincrinizados');
    Resumen.resumentList.add(Resumen(
        accion: 'Productos Sincronizados',
        cantidad: productos.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

Future downloadInvoices() async {
  final List<Factura> facturas = [];
  final List<Factura> facturaFinal = [];
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/Factura.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> clienteMap = json.decode(response.body);

    clienteMap.forEach((key, value) {
      final tempInvoice = Factura.fromMap(value);
      facturas.add(tempInvoice);
    });

    facturas.forEach((element) async {
      if (element.vendedorId == usuario) {
        await DatabaseHelper.instance.SincronizarFactura(element);
      }
    });

    // facturas.forEach((factura) async {
    //   await DatabaseHelper.instance.SincronizarFactura(factura);
    // });

    print('Facturas Sincronizados');

    Resumen.resumentList.add(Resumen(
        accion: 'Facturas Sincronizados',
        cantidad: facturas.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

void ObtenerFacturas() async {
  final List<Factura> facturas = [];
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/Factura.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> clienteMap = json.decode(response.body);

    clienteMap.forEach((key, value) {
      final tempInvoice = Factura.fromMap(value);
      facturas.add(tempInvoice);
    });

    facturas.forEach((factura) async {
      await DatabaseHelper.instance.SincronizarFactura(factura);
    });

    print('Facturas Sincronizados');

    Resumen.resumentList.add(Resumen(
        accion: 'Facturas Sincronizados',
        cantidad: facturas.length.toString()));
  } finally {
    client.close();
  }
}

// void ejecutarMetodos() {
//   //Decargar Usuarios
//   downNewUser();
//   //Cargar Usuarios
//   upNewUser();

//   //Cargar Clientes
//   uploadClients();
// }
Future uploadPayment() async {
  var pagos = await DatabaseHelper.instance.obtenerPagosASincornizar();

  var client = http.Client();
  try {
    pagos.forEach((element) async {
      var response = await client.post(
          Uri.parse('https://siga-d5296-default-rtdb.firebaseio.com/Pago.json'),
          body: json.encode(element.toJson()));
      var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final codeData = json.decode(response.body);
      final decodeData = codeData['name'];
      if (Response.isNotEmpty) {
        DatabaseHelper.instance
            .actualizarPagoCargado(element.id as int, decodeData)
            .then((value) => {
                  DatabaseHelper.instance
                      .obtenerPagoDetallessASincornizarPorId(element.id as int)
                      .then((value) => {sincronizarDetalle(value, decodeData)})
                });
      }
    });
    Resumen.resumentList
        .add(Resumen(accion: 'Pagos sincronizado', cantidad: pagos.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

sincronizarDetalle(List<PagoDetalle> pago, String _pagoIdFirebase) async {
  final List<Pago> pagos = [];
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final url = Uri.https(_baseUrl, 'PagoDetalle.json');
  pago.forEach((element) async {
    element.pagoIdFirebase = _pagoIdFirebase;
    final resp = await http.post(url, body: json.encode(element.toJson()));
    final decodeData = resp.body;

    if (decodeData.isNotEmpty) {
      DatabaseHelper.instance
          .actualizarPagoCargado(element.id as int, decodeData);
    }
  });

  Resumen.resumentList.add(Resumen(
      accion: 'Pago Detalle Cargado', cantidad: pagos.length.toString()));
}

//////////////////////////Usuarios /////////////////////////////////////////////////////
Future downNewUser() async {
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/Usuario.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> usuariosMap = json.decode(response.body);

    usuariosMap.forEach((key, value) {
      final tempUsuarios = Usuario.fromMap(value);

      var cargado =
          DatabaseHelper.instance.verificarUsuarioASincronizar(tempUsuarios);
    });
    print('Usuario Descargado para la prueba');

    Resumen.resumentList.add(Resumen(
        accion: 'Usuario Descargado o actualizado',
        cantidad: usuariosMap.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
    ;
  }
}

Future upNewUser() async {
  var usuarios = await DatabaseHelper.instance
      .obtenerListaDeUsuariosPendienteASincronizar(compagnia);

  var client = http.Client();
  try {
    usuarios.forEach((element) async {
      var response = await client.post(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/Usuario.json'),
          body: json.encode(element.toMap()));
      var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      if (Response.isNotEmpty) {
        DatabaseHelper.instance.actualizarUsarioCargado(element.id as int);
      }
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Usuario Sincronizados    ',
        cantidad: usuarios.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

//////////////////////////Clientes /////////////////////////////////////////////////////
Future uploadClients() async {
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
        await DatabaseHelper.instance
            .actualizarClientesCargado(element.id as int);
      }
    });
    print('Clientes Sincronizados');
    Resumen.resumentList.add(Resumen(
        accion: 'Clientes Sincronizados ',
        cantidad: clientes.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

Future downloadClients() async {
  final List<Cliente> clientes = [];
  var client = http.Client();
  try {
    var response = await client.get(
        Uri.parse(
            'https://siga-d5296-default-rtdb.firebaseio.com/Clientes.json'),
        headers: {"Content-Type": "application/json"});

    final Map<String, dynamic> clienteMap = json.decode(response.body);

    clienteMap.forEach((key, value) {
      final tempClientes = Cliente.fromMap(value);
      clientes.add(tempClientes);
    });
    print('Clientes Sincronizados');
    clientes.forEach((cliente) async {
      if (cliente.codigoVendedor == usuario) {
        if (cliente.activo == 1) {
          await DatabaseHelper.instance.customerExists(cliente);
        } else {
          await DatabaseHelper.instance.deleteExist(cliente);
        }
      }
    });
    print('Clientes Descargado');
    Resumen.resumentList.add(Resumen(
        accion: 'Clientes Descargado', cantidad: clientes.length.toString()));
  } finally {
    client.close();
    procentaje = procentaje + 9;
  }
}

void llamarMetodos() {
  // ------------------------- Usuario -------------------------
  // Bajar Usuarios

  print('Primero usuario');
  print(CurrentUserName);
  print('Segundo usuario');
  print(usuario);
  if (usuario == "") {
    if (usuariobool == false) {
      downNewUser();

      // Subir usuarios
      upNewUser();
      usuariobool = true;
    }
  }

  if (productosbool == false) {
// ------------------------- Productos -------------------------

    downproductos();
  }
  if (cientesbool == false) {
// ------------------------- Clientes -------------------------

    downloadClients();
    uploadClients();
    cientesbool = false;
  }
  if (pedidosbool == false) {
    // ------------------------- Pedidos -------------------------
    // downloadOrdes();
    // downloadOrderDetalls();
    uploadOrdes();
    pedidosbool = true;
  }
  if (facturabool == false) {
    downloadInvoices();
    // downloadInvoiceDetails();
    facturabool = true;
  }
  if (pagosbool == false) {
    // downloadPayment();
    uploadPayment();
    pagosbool = true;
  }
}

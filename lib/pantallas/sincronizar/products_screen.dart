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
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/clases/usuario.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
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
  int contador = 0;
  List<Resumen> resumenDeSincronizacion = [];

  @override
  void initState() {
    llamarMetodos();

    resumenDeSincronizacion = Resumen.obtenerResumen();
    Timer.periodic(Duration(seconds: 5), (timer) {
      // contador = contador + 1;
      // print(contador);
      resumenDeSincronizacion = Resumen.obtenerResumen();
    });
    super.initState();
    // resumenDeSincronizacion = Resumen.obtenerResumen();

    // super.initState();
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
        body: resumenDeSincronizacion.length > 0
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
                child: Text('Data en sincronizacion, regrese en un momento'),
              ));
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
    }
  }

  Future downloadInvoices() async {
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
        await DatabaseHelper.instance.customerExists(cliente);
      });
      print('Clientes Descargado');
      Resumen.resumentList.add(Resumen(
          accion: 'Clientes Descargado', cantidad: clientes.length.toString()));
    } finally {
      client.close();
    }
  }

  void llamarMetodos() {
    downNewUser();
    downloadInvoices();
  }
}

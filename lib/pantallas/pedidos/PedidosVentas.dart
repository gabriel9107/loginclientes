import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/pantallas/clientes/detalleDelCLiente.dart';
import 'package:sigalogin/ui/InputDecorations.dart';

import '../../clases/facturaDetalle.dart';
import '../../clases/pedidoDetalle.dart';
import '../../clases/pedidos.dart';
import '../../servicios/db_helper.dart';
import '../CartBottomNavBar.dart';
import '../NavigationDrawer.dart';
import '../buscar/buscarProductosEnPedidos.dart';
import '../busquedas/busquedaProductosenProducto.dart';

class CartPage extends StatefulWidget {
  String? clienteCodigo;
  String? nombreCliente;
  CartPage(this.clienteCodigo, this.nombreCliente);

  @override
  _mainPage createState() => _mainPage(clienteCodigo, nombreCliente);
}

class _mainPage extends State<CartPage> {
  String? clienteCodigo;

  String? nombreCliente;
  _mainPage(this.clienteCodigo, this.nombreCliente);

  late List<FacturaDetalle> detalleFactura = [];
  //  FacturaDetalle.getFacturaDetalle();
  String NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();

  bool resultado = FacturaDetalle.limpiarfacturas();

  int _lastIntegerSelected = 0;
  _refresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      detalleFactura = [];
    });
    return;
  }

  Future refresh() async {
    setState(() {
      detalleFactura = FacturaDetalle.getFacturaDetalle();
      NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: Text('Siga Mobile - Pedidos      Cliente : ' +
                this.nombreCliente.toString()),
            backgroundColor: const Color.fromARGB(255, 42, 135, 221),

            //Boton de Buscar
            actions: <Widget>[
              IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    TodosProductos =
                        (await DatabaseHelper.instance.getProductos());

                    await showSearch(
                        context: context,
                        delegate: MySearchDelegateParaProductosEnPedidos());

                    if (_lastIntegerSelected != null) {
                      setState(() {
                        refresh();
                      });
                    }
                  })
            ]),
        drawer: navegacions(),
        body: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: detalleFactura.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                          width: 670,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(0, 3))
                              ]),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            FacturaDetalle.remover(index);
                                            detalleFactura.removeAt(index);
                                            detalleFactura.remove(index);

                                            // detalleFactura[index].cantidadProducto -=
                                            // //     1;
                                            // print(detalleFactura[index]
                                            //     .cantidadProducto);

                                            // qty -= 1;
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 50,
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  height: 50,
                                  width: 70,
                                ),
                              ),
                              Container(
                                width: 450,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      detalleFactura[index].nombreProducto,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Codigo : " +
                                          detalleFactura[index].codigoProducto,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      detalleFactura[index]
                                          .montoproducto
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.red),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print('restando');
                                              detalleFactura[index]
                                                  .cantidadProducto += 1;
                                              FacturaDetalle.actualiarLinea(
                                                  index);
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.plus,
                                            color: Colors.white,
                                            size: 32,
                                          )),
                                      Text(
                                        detalleFactura[index]
                                            .cantidadProducto
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              detalleFactura[index]
                                                  .cantidadProducto -= 1;
                                              print(detalleFactura[index]
                                                  .cantidadProducto);

                                              FacturaDetalle.actualiarLinea(
                                                  index);

                                              // qty -= 1;
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            color: Colors.white,
                                            size: 35,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: _buildCartSummary(context, NumeroPedido,
                  clienteCodigo.toString(), nombreCliente),
            )
          ],
        ));
  }
}

_builCarItems(BuildContext context, int index) {}

_buildCartVentasSummary(BuildContext context, String? NumeroPedido,
    String? idCliente, String? clienteNombre) {
  FacturaMaster totales = FacturaMaster.totales();
  List<FacturaDetalle> detalle = FacturaDetalle.getFacturaDetalle();
}

_buildCartSummary(BuildContext context, String? NumeroPedido, String? idCliente,
    String? clienteNombre) {
  FacturaMaster totales = FacturaMaster.totales();
  List<FacturaDetalle> detalle = FacturaDetalle.getFacturaDetalle();

  return Container(
    padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Cantidad de Articulos ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
            Text(
              totales.cantidadArticulos.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Itbis',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              ("\$" + totales.montoImpuesto.toStringAsFixed(2)),
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total del pedido',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            Text(
              ("\$" + totales.totalApagar.toStringAsFixed(2)),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ],
        ),
        Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.greenAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: Size(680, 140), //////// HERE
                  ),
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: (() {
                    if (totales.totalApagar > 1) {
                      Pedido pedido = Pedido(
                          clienteId: idCliente.toString().trim(),
                          clienteNombre: clienteNombre.toString(),
                          fechaOrden: DateTime.now(),
                          impuestos: totales.montoImpuesto,
                          totalAPagar: totales.totalApagar,
                          compagnia: compagnia,
                          sincronizado: 0,
                          vendorId: usuario,
                          isDelete: 0,
                          estado: 'Pendiente');

                      DatabaseHelper.instance
                          .AddSalesWithId(pedido)
                          .then((value) => {
                                detalle.forEach((element) {
                                  PedidoDetalle detalle = new PedidoDetalle(
                                      codigo: element.codigoProducto,
                                      nombre: element.nombreProducto,
                                      cantidad: element.cantidadProducto,
                                      precio: element.montoproducto,
                                      pedidoId: value.toString(),
                                      compagnia: compagnia,
                                      isDelete: 0,
                                      sincronizado: 0);

                                  DatabaseHelper.instance
                                      .AddSalesDetalle(detalle);
                                })
                              });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          // builder: (context) => pedidop(), pedidosLista
                          builder: (context) =>
                              DetalleDelCliente(idCliente, clienteNombre)));
                      ListaProducto = false;
                      TodosProductos.clear();
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                  title: const Text('Notificacion :'),
                                  content: const Text(
                                      ('No existen detalle en el pedido, favor de agregar')),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("Ok"),
                                      ),
                                    )
                                  ]));
                    }
                  }))
            ]))
      ],
    ),
  );
}

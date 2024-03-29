import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../clases/facturaDetalle.dart';
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
      body: RefreshIndicator(
        onRefresh: refresh,
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
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: const SizedBox(
                        //     height: 50,
                        //     width: 100,
                        //   ),
                        // ),
                        Container(
                          width: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                detalleFactura[index].nombreProducto,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Codigo : " +
                                    detalleFactura[index].codigoProducto,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                detalleFactura[index].montoproducto.toString(),
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        print('restando');
                                        detalleFactura[index]
                                            .cantidadProducto += 1;
                                        FacturaDetalle.actualiarLinea(index);
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

                                        FacturaDetalle.actualiarLinea(index);

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
      bottomNavigationBar: CartBottomNavBar(
          NumeroPedido, clienteCodigo.toString(), nombreCliente),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../clases/ordenDeventa.dart';
import '../../servicios/db_helper.dart';

import 'CartBottomNavBarHistorico.dart';

class PedidoHistorico extends StatefulWidget {
  OrdenVenta pedidos;
  PedidoHistorico(this.pedidos);

  @override
  _mainPage createState() => _mainPage(pedidos);
}

class _mainPage extends State<PedidoHistorico> {
  OrdenVenta pedidos;

  _mainPage(this.pedidos);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Pedido de Ventas Cliente ' + this.pedidos.customerID.toString()),

          // backgroundColor: Color.fromARGB(255, 25, 28, 228),
        ),
        body: FutureBuilder<List<OrdenVentaDetalle>>(
          future:
              DatabaseHelper.instance.getDetallesporId(pedidos.id.toString()),
          builder: (BuildContext context,
              AsyncSnapshot<List<OrdenVentaDetalle>> snapshot) {
            final List<OrdenVentaDetalle>? detalles = snapshot.data;

            return ListView.builder(
                itemCount: detalles?.length,
                itemBuilder: (contex, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
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
                                    alignment: Alignment.center,
                                    child: const SizedBox(
                                      height: 50,
                                      width: 150,
                                    ),
                                  ),
                                  Container(
                                    width: 450,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          detalles![index].productCode,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          detalles![index].productName,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          detalles![index].price.toString(),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              child: Icon(
                                                CupertinoIcons.plus,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                          Text(
                                            detalles[index].qty.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // qty -= 1;
                                                });
                                              },
                                              child: Icon(
                                                CupertinoIcons.minus,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  );
                  // final detalleFactura = detalles![index];

                  // return Card(
                  //     child: Column(children: [
                  //   Text(detalleFactura.productCode.toString()),
                  //   Text(detalleFactura.productName.toString()),
                  //   Text(detalleFactura.qty.toString()),
                  //   Text(detalleFactura.price.toString()),
                  //   Text(detalleFactura.salesOrdersID.toString()),
                  //   Text(detalleFactura.iD.toString())
                  // ]));
                });
          },
        ),
        bottomNavigationBar: CartBottomNavBarHistorico(pedidos));
  }
}

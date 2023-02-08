import 'package:flutter/material.dart';
import 'package:sigalogin/clases/ordenDeventa.dart';
import 'package:sigalogin/pantallas/pedidosLista.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';
import '../clientes/detalleDelCLiente.dart';

class CartBottomNavBarHistorico extends StatelessWidget {
  OrdenVenta pedidos;
  CartBottomNavBarHistorico(this.pedidos);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     // Text(
                //     //   "Cantidad de Articulos",
                //     //   style: TextStyle(
                //     //       color: Color(0xFF4C54A5),
                //     //       fontSize: 22,
                //     //       fontWeight: FontWeight.bold),
                //     // ),
                //     // Text(
                //     //   '10',
                //     //   style: TextStyle(
                //     //       fontSize: 25,
                //     //       fontWeight: FontWeight.bold,
                //     //       color: Color(0xFF4C53A5)),
                //     // )
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub total",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      pedidos.totals,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total del pedido",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ("\$" + pedidos.totals),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                          // color: Color(0xFF4C53A5)
                          ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                        "Salir",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: (() {
//Guardar Factura

                        // DetalleDelCliente(totales.idClienteFactura)));
                      }),
                    )
                  ]),
                )
              ],
            )));
  }
}

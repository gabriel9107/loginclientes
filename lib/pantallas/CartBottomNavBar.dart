import 'package:flutter/material.dart';
import 'package:sigalogin/clases/ordenDeventa.dart';
import 'package:sigalogin/pantallas/pedidosLista.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/facturaDetalle.dart';
import '../clases/global.dart';
import 'clientes/detalleDelCLiente.dart';

class CartBottomNavBar extends StatelessWidget {
  String? NumeroPedido;
  CartBottomNavBar(this.NumeroPedido);
  @override
  Widget build(BuildContext context) {
    FacturaMaster totales = FacturaMaster.totales();
    List<FacturaDetalle> detalle = FacturaDetalle.getFacturaDetalle();

    return BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cantidad de Articulos",
                      style: TextStyle(
                          color: Color(0xFF4C54A5),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      totales.cantidadArticulos.toString(),
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
                      "Sub total",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ("\$" + totales.subtotal.toString()),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5)),
                    )
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Descuentos",
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       ("\$" + totales.montoDescuento.toString()),
                //       style: TextStyle(
                //           fontSize: 25,
                //           fontWeight: FontWeight.bold,
                //           color: Color(0xFF4C53A5)),
                //     )
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Itbis",
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       ("\$" + totales.montoImpuesto.toString()),
                //       style: TextStyle(
                //           fontSize: 25,
                //           fontWeight: FontWeight.bold,
                //           color: Color(0xFF4C53A5)),
                //     )
                //   ],
                // ),
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
                      ("\$" + totales.totalApagar.toString()),
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
                        "Guardar",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: (() {
                        OrdenVenta orden = OrdenVenta(
                            cash: totales.totalApagar.toString(),
                            ordenNumero: "1",
                            change: "0",
                            customerID: totales.idClienteFactura,
                            date: DateTime.now().toString(),
                            gPID: "",
                            isDelete: "0",
                            totals: totales.totalApagar,
                            userName: CurrentUserName,
                            vAT: totales.montoImpuesto,
                            status: "Activo",
                            commets: 'NO comentario');

                        DatabaseHelper.instance.AddSales(orden);

                        detalle.forEach((element) {
                          OrdenVentaDetalle detalleventa =
                              new OrdenVentaDetalle(
                                  salesOrdersID: "1",
                                  price: element.montoproducto,
                                  qty: element.cantidadProducto,
                                  productCode: element.codigoProducto,
                                  productName: element.nombreProducto);
                          DatabaseHelper.instance.AddSalesDetalle(detalleventa);
                        });

//Guardar Factura

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            // builder: (context) => pedidop(), pedidosLista
                            builder: (context) => pedidosLista()));
                        // DetalleDelCliente(totales.idClienteFactura)));
                      }),
                    )
                  ]),
                )
              ],
            )));
  }
}

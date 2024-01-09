import 'package:flutter/material.dart';
import 'package:sigalogin/clases/ordenDeventa.dart';
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/pantallas/pedidosLista.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/facturaDetalle.dart';
import '../clases/global.dart';
import 'clientes/detalleDelCLiente.dart';

class CartBottomNavBar extends StatelessWidget {
  String? NumeroPedido;
  String? idCliente;
  String? clienteNombre;
  CartBottomNavBar(this.NumeroPedido, this.idCliente, this.clienteNombre);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Itbis",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ("\$" + totales.montoImpuesto.toStringAsFixed(2)),
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
                      ("\$" + totales.totalApagar.toStringAsFixed(2)),
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
                        if (totales.totalApagar > 1) {
                          Pedido pedido = Pedido(
                              clienteId: this.idCliente.toString().trim(),
                              clienteNombre: this.clienteNombre.toString(),
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

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  // builder: (context) => pedidop(), pedidosLista
                                  builder: (context) => DetalleDelCliente(
                                      idCliente, this.clienteNombre)));

//limpiar lista
                          ListaProducto = false;
                          TodosProductos.clear();
                        } else {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                      title: const Text("Notificación :"),
                                      content: const Text(
                                          "No existe detalle en el pedido, favor de agregar"),
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
                      }),
                    )
                  ]),
                )
              ],
            )));
  }
}

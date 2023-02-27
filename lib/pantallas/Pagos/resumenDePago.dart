import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/ordenDeventa.dart';
import 'package:sigalogin/pantallas/Pagos/pago.dart';
import 'package:sigalogin/pantallas/pedidosLista.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/detalledePago.dart';
import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';
import '../../clases/modelos/pagodetalle.dart';
import '../alertas.dart';
import '../clientes/detalleDelCLiente.dart';
import '../clientes/listaClientes.dart';

class ResumenDePagos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var subtotal = PagoTemporal.obtenerSubtotal();
    var total = Pago.obtenermontodelpago();

    return BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detalle del Pago",
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal de Pago",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtotal.toString(),
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
                      "Total:	",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      total.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5)),
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
                        // onPrimary: Colors.white,
                        shadowColor: Colors.greenAccent,
                        // elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        minimumSize: Size(680, 140), //////// HERE
                      ),
                      child: Text(
                        "Finalizar Pago",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: (() {
                        if (subtotal != total) {
                          showAlertDialog(context);
                        } else {
                          Pago.guardarPago();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => clienteLista()));
                        }

                        //

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => clienteLista()));

//Guardar Factura
                        // // Pagos.eliminartodos();
                        // PagosDetalles.eliminarpago();

                        // DetalleDelCliente(totales.idClienteFactura)));
                      }),
                    )
                  ]),
                )
              ],
            )));
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("Favor de revisar la distribuacion en los pagos"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

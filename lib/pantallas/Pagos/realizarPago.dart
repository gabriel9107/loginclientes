import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';

import '../../clases/factura.dart';
import '../buscar/buscarFacturasParaPagos.dart';

class RealizarPago extends StatefulWidget {
  @override
  _realizarPagoPageState createState() => _realizarPagoPageState();
}

class _realizarPagoPageState extends State<RealizarPago> {
  List<DropdownButton<String>> menuItems = [];
  List<Factura> facturas = [];

  bool efectivo = false;

  final _formadepagoController = TextEditingController();
  final _bancoparaPagoController = TextEditingController();
  final _montoApagarController = TextEditingController();
  final _numerodechequeController = TextEditingController();
  final _fechaChequeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool efectivo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pagos'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {
              showSearch(context: context, delegate: BuscarFacturaEnPagos())
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Codigo de cliente :    7488803',
                style: TextStyle(fontSize: 15)),
            Text('Nombre de cliente : Aro y Motor (Guerra)',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            _form(efectivo),
            _list(facturas)
          ],
        ),
        // body:
      ),
      bottomNavigationBar: ResumenDePagos(),
    );
  }
}

//  bottomNavigationBar:
//           CartBottomNavBar(NumeroPedido, clienteCodigo.toString()),
//     );
_form(bool efectivo) => Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              value: "-1",
              items: [
                DropdownMenuItem(
                  child: Text("-Seleccionar una forma de pago"),
                  value: "-1",
                ),
                DropdownMenuItem(
                  child: Text("Efectivo"),
                  value: "1",
                ),
                DropdownMenuItem(
                  child: Text("Cheque"),
                  value: "2",
                ),
                DropdownMenuItem(
                  child: Text("Transferencia"),
                  value: "3",
                ),
              ],
              onChanged: (value) => {
                if (value == "1") {efectivo = true}
              },
            ),
            DropdownButtonFormField(
              value: "-1",
              items: [
                DropdownMenuItem(
                  child: Text("-Seleccionar un banco"),
                  value: "-1",
                ),
                DropdownMenuItem(
                  child: Text("POPULAR"),
                  value: "1",
                ),
                DropdownMenuItem(
                  child: Text("BHD"),
                  value: "2",
                ),
                DropdownMenuItem(
                  child: Text("Banreserva"),
                  value: "3",
                ),
                DropdownMenuItem(
                  child: Text("Scotia Bank"),
                  value: "4",
                ),
                DropdownMenuItem(
                  child: Text("APAP"),
                  value: "5",
                ),
                DropdownMenuItem(
                  child: Text("Banco Caribe"),
                  value: "6",
                ),
                DropdownMenuItem(
                  child: Text("Banco Cibao"),
                  value: "7",
                ),
                DropdownMenuItem(
                  child: Text("Banco de Ahorro y Credito Caribe"),
                  value: "8",
                ),
                DropdownMenuItem(
                  child: Text("Otros"),
                  value: "9",
                ),
              ],
              onChanged: null,
              hint: Text("Select Your Technology"),
              disabledHint: Text("First Select Your Field"),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor del pago	'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Num. Cheque	'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Fecha Cheque'),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Buscar Factura'),

                // color: darkBlueColor,
                // textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

_list(List<Factura> factura) => Expanded(
        child: Card(
      child: ListView.builder(
        itemCount: 10,
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
                  child: Row(children: [
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
                              onTap: () {},
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
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Numero de Factura : FVS002708 ",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Fecha Emision : 22/Jan/2019	",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            "Fecha Vencimiento : 08/Mar/2019	",
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Valor original : 6240.79	",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Valor Pagado : 5,891.30",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            "Saldo :",
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 100,
                            child: TextField(
                              // controller: textController,
                              decoration:
                                  InputDecoration(hintText: 'Salo A Pagar '),
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: true),
                              onTap: () {
                                // query = suggestion.facturaId.toString();
                              },
                            ),
                          ),
                          Text(
                            "",
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ])),
            )
          ]));
          // Container(
          //   width: 80,
          //   child: Text('Valor original	'),
          // ),
          // Container(
          //   width: 80,
          //   child: Text('6240.79'),
          // ),
          // Container(
          //   width: 80,
          //   child: Text('Valor pagado	'),
          // ),
          // Container(
          //   width: 80,
          //   child: Text('5,891.30'),
          // ),
          // Container(
          //   width: 80,
          //   child: Text('Saldo'),
          // ),
          // ]));
        },
      ),
    ));
// _list(List<Factura> facturas) => Expanded(
//       child: Card(
//         child: Scrollbar(
//           child: ListView.builder(
//             itemCount: 10,
//             itemBuilder: (context, index) {
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       child: Container(
//                         width: 670,
//                         height: 120,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 3,
//                                   blurRadius: 10,
//                                   offset: Offset(0, 3))
//                             ]),
//                         child: Row(
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               child: const SizedBox(
//                                 height: 50,
//                                 width: 150,
//                               ),
//                             ),
//                             Container(
//                               width: 450,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     '1',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     '1',
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                   Text(
//                                     '1',
//                                     style: TextStyle(
//                                         fontSize: 20, color: Colors.red),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(vertical: 10),
//                               child: Container(
//                                 padding: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                     color: Colors.red,
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     GestureDetector(
//                                         onTap: () {},
//                                         child: Icon(
//                                           CupertinoIcons.plus,
//                                           color: Colors.white,
//                                           size: 20,
//                                         )),
//                                     Text(
//                                       '1',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white),
//                                     ),
//                                     GestureDetector(
//                                         onTap: () {},
//                                         child: Icon(
//                                           CupertinoIcons.minus,
//                                           color: Colors.white,
//                                           size: 20,
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: 30,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(''),
//                                   Text(''),
//                                   GestureDetector(
//                                       onTap: () {},
//                                       child: Icon(
//                                         Icons.delete,
//                                         color: Colors.red,
//                                         size: 20,
//                                       )),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );

//   ListView.builder(
//   itemCount: suggestions.length,
//   itemBuilder: (context, index) {
//     final suggestion = suggestions[index];
//     return ListTile(
//       title: Text('Numero Factura: ' + suggestion.facturaId.toString(),
//           style: TextStyle(fontSize: 18)),
//       subtitle: Text('Monto total : ' + suggestion.montoFactura.toString()),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             width: 80,
//             child: Text('Monto Pendiente'),
//           ),

//           Container(
//             width: 60,
//             child: Text(suggestion.montoFactura),
//           ),
//           // Container(
//           //   child: Text('Prueba'),
//           // ),
//           // Container(
//           //   child: Text('Prueba'),
//           // ),
//           // ),

//           // Container(
//           //   color: Colors.red,
//           //   child: Text('Valor Pendiente'),
//           // ),

//           IconButton(onPressed: () {}, icon: Icon(Icons.payment)),
//           // Container(
//           //   width: 100,
//           //   child: TextField(
//           //     controller: textController,
//           //     decoration: InputDecoration(hintText: 'saldo '),
//           //     keyboardType: TextInputType.numberWithOptions(
//           //         signed: false, decimal: true),
//           //     onTap: () {
//           //       query = suggestion.facturaId.toString();
//           //     },
//           //   ),
//           // ),
//           Container(
//             alignment: Alignment.topRight,
//             child: ElevatedButton(
//               onPressed: () {
//                 Factura.addfacturaDetalle(Factura(
//                     facturaFecha: suggestion.facturaFecha,
//                     facturaId: suggestion.facturaId,
//                     facturaVencimiento: suggestion.facturaVencimiento,
//                     id: suggestion.id,
//                     metodoDePago: suggestion.metodoDePago,
//                     montoFactura: suggestion.montoFactura,
//                     pedidosId: suggestion.pedidosId,
//                     totalPagado: suggestion.totalPagado));

//                 // double price = suggestion.price as double;

//                 // FacturaDetalle.addfacturaDetalle(FacturaDetalle(
//                 //     facturaNumero: "1",
//                 //     codigoProducto: suggestion.productoCodigo.toString(),
//                 //     montoproducto:
//                 //         double.parse(suggestion.price.toString()),
//                 //     nombreProducto: suggestion.nombre.toString(),
//                 //     cantidadProducto:
//                 //         int.parse(textController.text.toString())));
//                 // close(context, null);
//               },
//               child: Text('Agregar'),
//             ),
//           )
//         ],
//       ),
//       onTap: () {
//         query = suggestion.facturaId.toString();
//       },
//     );
//   },
// );

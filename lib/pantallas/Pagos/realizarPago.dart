import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
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
  Future _refresh() async {
    setState(() {
      facturas = Factura.obtenerfacturadetalle();
      //  FacturaDetalle.getFacturaDetalle();
      // NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
    });
  }

  bool efectivo = false;

  int intBanco = 0;
  int formaDePago = 0;

  @override
  Widget build(BuildContext context) {
    bool efectivo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pagos'),
        actions: [],
      ),
      body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Form(
                    child: Column(children: <Widget>[
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
                      print(value),
                      if (value == '1')
                        {
                          print(value),
                          setState(() {
                            this.efectivo = false;
                          })
                        }
                      else
                        {
                          setState(() {
                            this.efectivo = true;
                            print(this.efectivo);
                          })
                        }

                      // if (value == "1") {efectivo = true}
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
                    onChanged: this.efectivo
                        ? (value) => setState(() => {this.efectivo = true})
                        : null,
                    hint: Text("Select Your Technology"),
                    disabledHint: Text("First Select Your Field"),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Valor del pago	',
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Num. Cheque	'),
                    enabled: this.efectivo ? true : false,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(labelText: 'Fecha Cheque'),
                    enabled: this.efectivo ? true : false,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                      onPressed: () => {
                        showSearch(
                            context: context, delegate: BuscarFacturaEnPagos())
                      },
                      child: Text('Buscar Factura'),

                      // color: darkBlueColor,
                      // textColor: Colors.white,
                    ),
                  ),
                ]))),
            Expanded(
                child: RefreshIndicator(
                    child: ListView.builder(
                      itemCount: facturas.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  width: 720,
                                  height: 100,
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
                                        width: 15,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                        ),
                                      ),
                                      Container(
                                        width: 30,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
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
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Num Factura		: ' +
                                                  facturas[index]
                                                      .facturaId
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Fecha Emsión	 : ' +
                                                  facturas[index]
                                                      .facturaFecha
                                                      .toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              'Fecha Vencimiento	: ' +
                                                  facturas[index]
                                                      .facturaVencimiento
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Valor original		 : ' +
                                                  facturas[index].montoFactura,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Valor pagado		 : ' +
                                                  facturas[index]
                                                      .totalPagado
                                                      .toString(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Container(
                                              width: 100,
                                              child: TextField(
                                                // controller: textController,
                                                decoration: InputDecoration(
                                                    hintText: 'Salo A Pagar '),
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        signed: false,
                                                        decimal: true),
                                                onTap: () {
                                                  // query = suggestion.facturaId.toString();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    onRefresh: _refresh))
          ])),
      bottomNavigationBar: ResumenDePagos(),
    );
  }
}

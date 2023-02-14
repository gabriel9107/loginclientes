import 'package:flutter/material.dart';

import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/facturaM.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';

import '../../clases/detalledePago.dart';
import '../buscar/buscarFacturasParaPagos.dart';

class RealizarPagodeprueba extends StatefulWidget {
  @override
  _realizarPagoPageState createState() => _realizarPagoPageState();
}

class _realizarPagoPageState extends State<RealizarPagodeprueba> {
  List<DropdownButton<String>> menuItems = [];
  double subtotal = 0;
  double total = 0;

  List<PagosDetalles> facturas = [];
  // List<Factura> facturas = [];
  Future _refresh() async {
    setState(() {
      // facturas = Factura.obtenerfacturadetalle();
      facturas = PagosDetalles.getDetalleFactura();

      //  FacturaDetalle.getFacturaDetalle();
      // NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
    });
  }

  Future _asyncInputDialog(BuildContext context, int index) async {
    String montoApagar = '';
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Saldo a Pagar'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Monto', hintText: '10,000.00'),
                onChanged: (value) {
                  montoApagar = value;
                },
              ))
            ],
          ),
          actions: [],
        );
      },
    );
  }

  bool efectivo = false;

  int intBanco = 0;
  int formaDePago = 0;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    bool efectivo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pagos'),
        actions: [],
      ),
      body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
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
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              width: 750,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 3))
                                  ]),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: const SizedBox(
                                      height: 10,
                                      width: 15,
                                    ),
                                  ),

                                  Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Num Factura : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'FVS002708'
                                          // +
                                          //     facturas[index]
                                          //         .facturaFecha
                                          //         .toString()
                                          ,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Fecha Emsión	',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          facturas[index]
                                              .fechaEmision
                                              .toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Fecha Vencimiento',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          (facturas[index]
                                              .fechavencimiento
                                              .toString()),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Valor original	',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          facturas[index]
                                              .valorfactura
                                              .toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Valor pendiente ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          facturas[index]
                                              .valorpendiente
                                              .toString()
                                          // +
                                          //     facturas[index]
                                          //         .facturaFecha
                                          //         .toString()
                                          ,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    child: Column(
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Saldo ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 120,
                                          child: TextField(
                                            controller: textController,
                                            decoration: InputDecoration(
                                                hintText: 'Salo A Pagar '),
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false,
                                                    decimal: true),
                                            onTap: () {
                                              print(textController);
                                              // query = suggestion.facturaId.toString();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: ElevatedButton(
                                        child: Icon(Icons.add),
                                        onPressed: () {
                                          int? _index = index as int;

                                          _asyncInputDialog(context, _index);
                                          // var factura = new PagosDetalles(
                                          //     ordeDePago: "1",
                                          //     numeroDeFactura: facturas[index]
                                          //         .facturaId
                                          //         .toString(),
                                          //     montoPagado: 1000,
                                          //     valorfactura: 9692.32,
                                          //     valorpendiente: 8692.32,
                                          //     activo: 1);
                                          // PagosDetalles.agregarFacturasaPagos(
                                          //     factura);
                                        }),
                                  )
                                  // Container(
                                  //   width: 50,
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceAround,
                                  //     children: [
                                  //       Text(
                                  //         '',
                                  //         style: TextStyle(
                                  //             fontSize: 12,
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       Icon(
                                  //         Icons.add,
                                  //         color: Colors.blue,
                                  //       ),
                                  //       Icon(
                                  //         Icons.delete,
                                  //         color: red,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),

                                  // Container(
                                  //   width: 250,
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceAround,
                                  //     children: [
                                  //       Text(
                                  //         'Valor original		 : ' +
                                  //             facturas[index].montoFactura,
                                  //         style: TextStyle(
                                  //             fontSize: 12,
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       Text(
                                  //         'Valor pagado		 : ' +
                                  //             facturas[index]
                                  //                 .totalPagado
                                  //                 .toString(),
                                  //         style: TextStyle(fontSize: 14),
                                  //       ),
                                  //       Container(
                                  //         width: 100,
                                  //         child: TextField(
                                  //           // controller: textController,
                                  //           decoration: InputDecoration(
                                  //               hintText: 'Salo A Pagar '),
                                  //           keyboardType: TextInputType
                                  //               .numberWithOptions(
                                  //                   signed: false,
                                  //                   decimal: true),
                                  //           onTap: () {
                                  //             // query = suggestion.facturaId.toString();
                                  //           },
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
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

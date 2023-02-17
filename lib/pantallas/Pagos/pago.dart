import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';

import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';

import '../../clases/modelos/pago.dart';
import '../../clases/modelos/pagodetalle.dart';
import '../buscar/buscarFacturasParaPagos.dart';

class RealizarPagodeprueba extends StatefulWidget {
  String nombreCliente;
  String clienteid;
  RealizarPagodeprueba(this.nombreCliente, this.clienteid);
  @override
  _realizarPagoPageState createState() =>
      _realizarPagoPageState(this.nombreCliente, this.clienteid);
}

class _realizarPagoPageState extends State<RealizarPagodeprueba> {
  String nombreCliente;
  String clienteid;
  _realizarPagoPageState(this.nombreCliente, this.clienteid);
  double? valordelpago = 0;
  List<DropdownButton<String>> menuItems = [];
  double subtotal = 0;
  double total = 0;

  List<Pagodetalle> facturas = [];

  // List<Factura> facturas = [];
  Future _refresh() async {
    setState(() {
      // facturas = Factura.obtenerfacturadetalle();
      facturas = Pagodetalle.getDetalleFactura();
      valordelpago = Pago.obtenermontodelpago();

      //  FacturaDetalle.getFacturaDetalle();
      // NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
    });
  }

  bool efectivo = false;

  int intBanco = 0;
  int formaDePago = 0;

  @override
  Widget build(BuildContext context) {
    TextEditingController valordelpagoController = TextEditingController();

    TextEditingController formadelpagoController = TextEditingController();
    TextEditingController bancodelpagoController = TextEditingController();
    TextEditingController numerodechequeController = TextEditingController();
    TextEditingController fechaChequeController = TextEditingController();

    valordelpagoController.text = valordelpago.toString();
    List<TextEditingController> _controllers = [];

    Future llenarformulario(double? valordelpago) async {
      // formadelpagoController.text = "1";
    }

    bool efectivo = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pagos  A : ' + this.nombreCliente.toString()),
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
                controller: valordelpagoController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: 'Valor del pago	',
                ),
              ),
              TextFormField(
                controller: numerodechequeController,
                decoration: InputDecoration(labelText: 'Num. Cheque	'),
                enabled: this.efectivo ? true : false,
              ),
              TextFormField(
                controller: fechaChequeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Fecha Cheque'),
                enabled: this.efectivo ? true : false,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    child: Text('Buscar Factura'),
                    onPressed: () async {
                      valordelpago =
                          double.tryParse(valordelpagoController.text);

                      Pago.actualizarmontodelpago(valordelpago as double);
                      if (valordelpago != null) {
                        Pago.actualizarpago(Pago(
                            clienteId: int.parse(clienteid),
                            clienteNombre: nombreCliente,
                            formadePago: formadelpagoController.text,
                            valordelpago: valordelpago as double,
                            banco: bancodelpagoController.text,
                            vendedor: usuario));

                        Pago.agregarpago(Pago(
                            clienteId: int.parse(clienteid),
                            clienteNombre: nombreCliente,
                            formadePago: formadelpagoController.text,
                            valordelpago: valordelpago as double,
                            vendedor: usuario));
                        await showSearch(
                            context: context, delegate: BuscarFacturaEnPagos());

                        setState(() {
                          _refresh();
                        });
                      }
                    }
                    // color: darkBlueColor,
                    // textColor: Colors.white,
                    ),
              ),
            ]))),
        Expanded(
          child: ListView.builder(
            itemCount: facturas.length,
            itemBuilder: (BuildContext context, int index) {
              _controllers.add(new TextEditingController());

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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    facturas[index].numeroDeFactura
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    facturas[index].fechaEmision.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    facturas[index].valorfactura.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    facturas[index].valorpendiente.toString()
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
                                      controller: _controllers[index],
                                      decoration: InputDecoration(
                                        labelText: facturas[index]
                                            .montoPagado
                                            .toString(),
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: false, decimal: true),
                                      onTap: () {
                                        // query = suggestion.facturaId.toString();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 30,
                              child: ElevatedButton(
                                  child: Icon(Icons.add),
                                  onPressed: () {
                                    int? _index = index as int;
                                    double? monto = double.tryParse(
                                        _controllers[index].text);

                                    Pagodetalle.actualizardetalle(index, monto);
                                    setState(() {
                                      _refresh();
                                    });
                                  }),
                            ),
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: 30,
                              child: ElevatedButton(
                                  child: Icon(
                                    Icons.delete,
                                    size: 10,
                                    color: red,
                                  ),
                                  onPressed: () {
                                    int? _index = index as int;
                                    double? monto = double.tryParse(
                                        _controllers[index].text);

                                    Pagodetalle.eliminarpago(index);
                                    setState(() {
                                      _refresh();
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ])),
      bottomNavigationBar: ResumenDePagos(),
    );
  }
}

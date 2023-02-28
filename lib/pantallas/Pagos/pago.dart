// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sigalogin/clases/global.dart';
// import 'dart:math' as math;
// import 'package:intl/intl.dart';
// import 'package:sigalogin/clases/themes.dart';
// import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';

// import '../../clases/modelos/pago.dart';
// import '../../clases/modelos/pagodetalle.dart';
// import '../buscar/buscarFacturasParaPagos.dart';

// class RealizarPagodeprueba extends StatefulWidget {
//   String nombreCliente;
//   String clienteid;
//   RealizarPagodeprueba(this.nombreCliente, this.clienteid);
//   @override
//   _realizarPagoPageState createState() =>
//       _realizarPagoPageState(this.nombreCliente, this.clienteid);
// }

// class _realizarPagoPageState extends State<RealizarPagodeprueba> {
//   String nombreCliente;
//   String clienteid;
//   _realizarPagoPageState(this.nombreCliente, this.clienteid);
//   double? valordelpago = 0;
//   List<DropdownButton<String>> menuItems = [];
//   double subtotal = 0;
//   double total = 0;

//   List<PagoDetalle> facturas = [];
//   List<PagoTemporal> facturaTemp = [];

//   // List<Factura> facturas = [];
//   Future _refresh() async {
//     setState(() {
//       // facturas = Factura.obtenerfacturadetalle();
//       facturaTemp = PagoTemporal.getDetalleFactura();
//       valordelpago = Pago.obtenermontodelpago();

//       //  FacturaDetalle.getFacturaDetalle();
//       // NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
//     });
//   }

//   bool efectivo = false;

//   int intBanco = 0;
//   int formaDePago = 0;

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController valordelpagoController = TextEditingController();
//     TextEditingController formadelpagoController = TextEditingController();
//     TextEditingController bancodelpagoController = TextEditingController();
//     TextEditingController numerodechequeController = TextEditingController();
//     TextEditingController fechaChequeController = TextEditingController();

//     valordelpagoController.text = valordelpago.toString();
//     List<TextEditingController> _controllers = [];

//     Future llenarformulario(double? valordelpago) async {
//       // formadelpagoController.text = "1";
//     }

//     bool efectivo = false;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Realizar Pagos  A : ' + this.nombreCliente.toString()),
//         actions: [],
//       ),
//       body: Center(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//                   Widget>[
//         Container(
//             color: Colors.white,
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//             child: Form(
//                 child: Column(children: <Widget>[
//               DropdownButtonFormField(
//                 value: "-1",
//                 items: [
//                   DropdownMenuItem(
//                     child: Text("-Seleccionar una forma de pago"),
//                     value: "-1",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Efectivo"),
//                     value: "1",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Cheque"),
//                     value: "2",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Transferencia"),
//                     value: "3",
//                   ),
//                 ],
//                 onChanged: (value) => {
//                   print(value),
//                   if (value == '1')
//                     {
//                       print(value),
//                       setState(() {
//                         this.efectivo = false;
//                       })
//                     }
//                   else
//                     {
//                       setState(() {
//                         this.efectivo = true;
//                         print(this.efectivo);
//                       })
//                     }

//                   // if (value == "1") {efectivo = true}
//                 },
//               ),
//               DropdownButtonFormField(
//                 value: "-1",
//                 items: [
//                   DropdownMenuItem(
//                     child: Text("-Seleccionar un banco"),
//                     value: "-1",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("POPULAR"),
//                     value: "1",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("BHD"),
//                     value: "2",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Banreserva"),
//                     value: "3",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Scotia Bank"),
//                     value: "4",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("APAP"),
//                     value: "5",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Banco Caribe"),
//                     value: "6",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Banco Cibao"),
//                     value: "7",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Banco de Ahorro y Credito Caribe"),
//                     value: "8",
//                   ),
//                   DropdownMenuItem(
//                     child: Text("Otros"),
//                     value: "9",
//                   ),
//                 ],
//                 onChanged: this.efectivo
//                     ? (value) => setState(() => {this.efectivo = true})
//                     : null,
//                 hint: Text("Select Your Technology"),
//                 disabledHint: Text("First Select Your Field"),
//               ),
//               TextFormField(
//                 inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
//                 controller: valordelpagoController,
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 decoration: InputDecoration(
//                   labelText: 'Valor del pago	',
//                 ),
//               ),
//               TextFormField(
//                 controller: numerodechequeController,
//                 decoration: InputDecoration(labelText: 'Num. Cheque	'),
//                 enabled: this.efectivo ? true : false,
//               ),
//               TextFormField(
//                 controller: fechaChequeController,
//                 keyboardType: TextInputType.datetime,
//                 decoration: InputDecoration(labelText: 'Fecha Cheque'),
//                 enabled: this.efectivo ? true : false,
//               ),
//               Container(
//                 alignment: Alignment.topLeft,
//                 child: ElevatedButton(
//                     child: Text('Buscar Factura'),
//                     onPressed: () async {
//                       // valordelpago =
//                       // var montoA = double.tryParse(valordelpagoController.text);

//                       // Pago.actualizarmontodelpago(valordelpago as double);
//                       if (valordelpago != null) {
//                         Pago.actualizarmontodelpago(
//                             valordelpagoController.value.text);
//                         Pago.actualizarpago(this.clienteid.toString());
//                         // Pago.agregarpago(Pago(
//                         //     clienteId: int.parse(clienteid),
//                         //     clienteNombre: nombreCliente,
//                         //     formadePago: formadelpagoController.text,
//                         //     valordelpago: valordelpago as double,
//                         //     vendedor: usuario));
//                         await showSearch(
//                             context: context, delegate: BuscarFacturaEnPagos());

//                         setState(() {
//                           _refresh();
//                         });
//                       }
//                     }
//                     // color: darkBlueColor,
//                     // textColor: Colors.white,
//                     ),
//               ),
//             ]))),
//         Expanded(
//           child: ListView.builder(
//             itemCount: facturaTemp.length,
//             itemBuilder: (BuildContext context, int index) {
//               _controllers.add(new TextEditingController());

//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5),
//                       child: Container(
//                         width: 750,
//                         height: 100,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(5),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.grey.withOpacity(0.5),
//                                   spreadRadius: 1,
//                                   blurRadius: 5,
//                                   offset: Offset(0, 3))
//                             ]),
//                         child: Row(
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               child: const SizedBox(
//                                 height: 10,
//                                 width: 15,
//                               ),
//                             ),
//                             Container(
//                               width: 100,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Num Factura : ',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     facturaTemp[index].facturaId
//                                     // +
//                                     //     facturas[index]
//                                     //         .facturaFecha
//                                     //         .toString()
//                                     ,
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 100,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Fecha Emsión	',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     facturaTemp[index].fechaFactura,
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 100,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Fecha Vencimiento',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     facturaTemp[index].fechaVencimiento,
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 100,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Valor original	',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     facturaTemp[index].valorFactura.toString(),
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 100,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Valor pendiente ',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     facturaTemp[index]
//                                         .valorPendiente
//                                         .toString(),
//                                     // facturas[index].valorpendiente.toString()
//                                     // +
//                                     //     facturas[index]
//                                     //         .facturaFecha
//                                     //         .toString()

//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 120,
//                               child: Column(
//                                 // crossAxisAlignment:
//                                 //     CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Saldo ',
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Container(
//                                     width: 120,
//                                     child: TextField(
//                                       controller: _controllers[index],
//                                       decoration: InputDecoration(
//                                         labelText: facturaTemp[index]
//                                             .montoAplicado
//                                             .toString(),
//                                       ),
//                                       keyboardType:
//                                           TextInputType.numberWithOptions(
//                                               signed: false, decimal: true),
//                                       onTap: () {
//                                         // query = suggestion.facturaId.toString();
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 30,
//                               child: ElevatedButton(
//                                   child: Icon(Icons.add),
//                                   onPressed: () {
//                                     int? _index = index as int;
//                                     double? monto = double.tryParse(
//                                         _controllers[index].text);

//                                     PagoTemporal.actualizardetalle(
//                                         index, monto);
//                                     setState(() {
//                                       _refresh();
//                                     });
//                                   }),
//                             ),
//                             Container(
//                               width: 10,
//                             ),
//                             Container(
//                               width: 30,
//                               child: ElevatedButton(
//                                   child: Icon(
//                                     Icons.delete,
//                                     size: 10,
//                                     color: red,
//                                   ),
//                                   onPressed: () {
//                                     int? _index = index as int;
//                                     double? monto = double.tryParse(
//                                         _controllers[index].text);

//                                     PagoTemporal.eliminarpago(index);
//                                     setState(() {
//                                       _refresh();
//                                     });
//                                   }),
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         )
//       ])),
//       bottomNavigationBar: ResumenDePagos(),
//     );
//   }
// }

// class PagoTemporal {
//   PagoTemporal(
//       {required this.compagni,
//       required this.fechaFactura,
//       required this.fechaVencimiento,
//       required this.facturaId,
//       required this.id,
//       required this.isDelete,
//       required this.montoAplicado,
//       required this.sincronizado,
//       required this.valorFactura,
//       required this.montoDeFacturaAlMomento,
//       this.valorPendiente});

//   int? id;
//   String facturaId;
//   String fechaFactura;
//   String fechaVencimiento;
//   double montoAplicado;
//   double valorFactura;
//   double montoDeFacturaAlMomento;
//   double? valorPendiente;
//   int isDelete;
//   int sincronizado;
//   int compagni;

//   static List<PagoTemporal> pagos = [];

//   static void agregarFacturasaPagos(PagoTemporal pago) {
//     return pagos.add(pago);
//   }

//   static List<PagoTemporal> getDetalleFactura() {
//     return pagos;
//   }

//   static eliminarpago(int index) {
//     pagos.removeAt(index);
//     pagos.remove(index);
//     return null;
//   }

//   static actualizardetalle(int index, double? monto) {
//     if (monto != null) {
//       pagos[index].montoAplicado = monto;
//     }
//   }

//   static double obtenerSubtotal() {
//     if (pagos.length > 0) {
//       double monto = pagos
//           .map((e) => e.montoAplicado)
//           .reduce((value, element) => value + element);
//       if (monto != 0) {
//         return monto;
//       }
//     }
//     return 0;
//   }
// }

// class DecimalTextInputFormatter extends TextInputFormatter {
//   DecimalTextInputFormatter({required this.decimalRange})
//       : assert(decimalRange == null || decimalRange > 0);

//   final int decimalRange;

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue, // unused.
//     TextEditingValue newValue,
//   ) {
//     TextSelection newSelection = newValue.selection;
//     String truncated = newValue.text;

//     if (decimalRange != null) {
//       String value = newValue.text;

//       if (value.contains(".") &&
//           value.substring(value.indexOf(".") + 1).length > decimalRange) {
//         truncated = oldValue.text;
//         newSelection = oldValue.selection;
//       } else if (value == ".") {
//         truncated = "0.";

//         newSelection = newValue.selection.copyWith(
//           baseOffset: math.min(truncated.length, truncated.length + 1),
//           extentOffset: math.min(truncated.length, truncated.length + 1),
//         );
//       }

//       return TextEditingValue(
//         text: truncated,
//         selection: newSelection,
//         composing: TextRange.empty,
//       );
//     }
//     return newValue;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigalogin/clases/global.dart';
import 'dart:math' as math;
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/modelos/pago.dart';
import '../../clases/modelos/pagodetalle.dart';
import '../buscar/buscarFacturasParaPagos.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  List<PagoDetalle> facturas = [];
  List<PagoTemporal> facturaTemp = [];

  String? _selectedValue;
  String? _selectedValueFormaDePago;
  List<String> ListaDeBancos = [
    'POPULAR',
    'BHD',
    'Banreserva',
    'Scotia Bank',
    'APAP',
    'Banco Caribe',
    'Banco Cibao',
    'Banco de Ahorro y Credito Caribe',
    'Otros'
  ];
  List<String> ListaFormaDepago = [
    'Efectivo',
    'Cheque',
    'Transferencia',
    'Otros'
  ];
  // List<Factura> facturas = [];
  Future _refresh() async {
    setState(() {
      // facturas = Factura.obtenerfacturadetalle();
      facturaTemp = PagoTemporal.getDetalleFactura();
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
    TextEditingController formadelpagoController = TextEditingController();
    TextEditingController valordelpagoController = TextEditingController();
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
              // DropdownButtonFormField(
              //   value: 0,
              //   items: [
              //     DropdownMenuItem(
              //       child: Text("-Seleccionar una forma de pago"),
              //       value: 0,
              //     ),
              //     DropdownMenuItem(
              //       child: Text("Efectivo"),
              //       value: 1,
              //     ),
              //     DropdownMenuItem(
              //       child: Text("Cheque"),
              //       value: 2,
              //     ),
              //     DropdownMenuItem(
              //       child: Text("Transferencia"),
              //       value: 3,
              //     ),
              //   ],
              //   onChanged: (value) => {
              //     if (value == 1)
              //       {
              //         formadelpagoController.text = 'Efectivo',
              //         this.efectivo = true,
              //         print(formadelpagoController.text)
              //       },
              //     if (value == 2)
              //       {
              //         formadelpagoController.text = 'Cheque',
              //         this.efectivo = false
              //       },
              //     if (value == 3)
              //       {
              //         formadelpagoController.text = 'Transferencia',
              //         this.efectivo = false
              //       }
              //   },
              // ),
              DropdownButtonFormField<String>(
                disabledHint: Text("-Seleccionar una forma de Pago"),
                value: _selectedValueFormaDePago,
                onChanged: (value) => {
                  if (value == 'Efectivo')
                    {this.efectivo = true, print(this.efectivo)},
                  setState(() => _selectedValueFormaDePago = value)
                },
                items: ListaFormaDepago.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
              TextFormField(
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                controller: valordelpagoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor del pago	',
                ),
              ),
              DropdownButtonFormField<String>(
                disabledHint: Text("-Seleccionar un banco"),
                value: _selectedValue,
                onChanged: this.efectivo
                    ? null
                    : (value) => {setState(() => _selectedValue = value)},
                //  this.efectivo
                //     ? (value) => setState(() => _selectedValue = value)
                //     : null,
                items: ListaDeBancos.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),

              // DropdownButtonFormField(
              //     value: 0,
              //     items: [
              //       DropdownMenuItem(
              //         child: Text("-Seleccionar un banco"),
              //         value: 0,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("POPULAR"),
              //         value: 1,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("BHD"),
              //         value: 2,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("Banreserva"),
              //         value: 3,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("Scotia Bank"),
              //         value: 4,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("APAP"),
              //         value: 5,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("Banco Caribe"),
              //         value: 6,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("Banco Cibao"),
              //         value: 7,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("Banco de Ahorro y Credito Caribe"),
              //         value: 9,
              //       ),
              //       DropdownMenuItem(
              //         child: Text("Otros"),
              //         value: 9,
              //       ),
              //     ],
              //     onChanged: this.efectivo
              //         ? null
              //         : (value) {
              //             switch (value) {
              //               case 1:
              //                 bancodelpagoController.text = 'POPULAR';
              //                 break;
              //               case 2:
              //                 bancodelpagoController.text = 'BHD';
              //                 break;
              //               case 3:
              //                 bancodelpagoController.text = 'Banreserva';
              //                 break;
              //               case 4:
              //                 bancodelpagoController.text = 'Scotia Bank';
              //                 break;
              //               case 5:
              //                 bancodelpagoController.text = 'APAP';
              //                 break;
              //               case 6:
              //                 bancodelpagoController.text = 'Banco Caribe';
              //                 break;
              //               case 7:
              //                 bancodelpagoController.text = 'Banco Cibao';
              //                 break;
              //               case 8:
              //                 bancodelpagoController.text =
              //                     'Banco de Ahorro y Credito Caribe';
              //                 break;
              //               default:
              //             }
              //           }

              //     // onChanged: this.efectivo
              //     //     ? (value) => setState(() => {this.efectivo = true})
              //     //     : null,
              //     // hint: Text("Select Your Technology"),
              //     // disabledHint: Text("First Select Your Field"),
              //     ),
              TextFormField(
                controller: numerodechequeController,
                decoration: InputDecoration(labelText: 'Num. Cheque	'),
                enabled: this.efectivo ? false : true,
              ),
              TextFormField(
                  controller: fechaChequeController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(labelText: 'Fecha Cheque'),
                  enabled: this.efectivo ? false : true,
                  onTap: () async {
                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(new FocusNode());

                    // date = (await showDatePicker(
                    //     context: context,
                    //     initialDate: DateTime.now(),
                    //     firstDate: DateTime(1900),
                    //     lastDate: DateTime(2100)));
                    // fechaChequeController.text = date as String;
                  }),
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    child: Text('Buscar Factura'),
                    onPressed: () async {
                      if (valordelpago != null) {
                        Pago.actualizarmontodelpago(
                            valordelpagoController.value.text);
                        Pago.actualizarpago(this.clienteid.toString(),
                            _selectedValueFormaDePago);

                        await showSearch(
                            context: context, delegate: BuscarFacturaEnPagos());

                        setState(() {
                          _refresh();
                        });
                      }
                    }),
              ),
            ]))),
        Expanded(
          child: ListView.builder(
            itemCount: facturaTemp.length,
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
                                    facturaTemp[index].facturaId,
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
                                    'Fecha Emisión	',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    facturaTemp[index].fechaFactura.toString(),
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
                                    facturaTemp[index]
                                        .fechaVencimiento
                                        .toString(),
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
                                    facturaTemp[index]
                                        .valorFactura
                                        .toStringAsFixed(2),
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
                                    facturaTemp[index]
                                        .valorPendiente
                                        .toString(),
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
                                        labelText: facturaTemp[index]
                                            .montoAplicado
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
                              height: 25,
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  int? _index = index as int;
                                  double? monto =
                                      double.tryParse(_controllers[index].text);

                                  PagoTemporal.actualizardetalle(index, monto);
                                  PagoTemporal.actualizardetalle(index, monto);
                                  setState(() {
                                    _refresh();
                                  });
                                },
                              ),
                            ),
                            // Container(
                            //   width: 30,
                            //   child: ElevatedButton(
                            //       child: Icon(Icons.add),
                            //       onPressed: () {
                            //         int? _index = index as int;
                            //         double? monto = double.tryParse(
                            //             _controllers[index].text);

                            //         PagoTemporal.actualizardetalle(
                            //             index, monto);
                            //         setState(() {
                            //           _refresh();
                            //         });
                            //       }),
                            // ),
                            Container(
                              width: 10,
                            ),

                            Container(
                              width: 20,
                              child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  int? _index = index as int;
                                  double? monto =
                                      double.tryParse(_controllers[index].text);

                                  PagoTemporal.eliminarpago(index);
                                  setState(() {
                                    _refresh();
                                  });
                                },
                              ),
                            )
                            // Container(
                            //   width: 30,
                            //   child: ElevatedButton(
                            //       child: Icon(
                            //         Icons.delete,
                            //         size: 10,
                            //         color: red,
                            //       ),
                            //       onPressed: () {

                            //       }),
                            // )
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

class PagoTemporal {
  PagoTemporal(
      {required this.compagni,
      required this.fechaFactura,
      required this.fechaVencimiento,
      required this.facturaId,
      required this.id,
      required this.isDelete,
      required this.montoAplicado,
      required this.sincronizado,
      required this.valorFactura,
      required this.montoDeFacturaAlMomento,
      this.valorPendiente});

  int? id;
  String facturaId;
  String fechaFactura;
  String fechaVencimiento;
  double montoAplicado;
  double valorFactura;
  double montoDeFacturaAlMomento;
  double? valorPendiente;
  int isDelete;
  int sincronizado;
  int compagni;

  static List<PagoTemporal> pagos = [];

  static void agregarFacturasaPagos(PagoTemporal pago) {
    return pagos.add(pago);
  }

  static List<PagoTemporal> getDetalleFactura() {
    return pagos;
  }

  static void guardarDetallePago(int pagoId, String formaPago) {
    pagos.forEach((element) {
      var detale = PagoDetalle(
          pagoId: pagoId,
          formaDePago: formaPago,
          compagni: element.compagni,
          facturaId: element.facturaId,
          id: 0,
          activo: 0,
          isDelete: 0,
          montoAplicado: element.montoAplicado,
          sincronizado: 0,
          montoDeFacturaAlMomento: element.montoDeFacturaAlMomento);
      DatabaseHelper.instance.aregardetalledePagoAsincronizar(detale);
    });
  }

  static eliminarpago(int index) {
    pagos.removeAt(index);
    pagos.remove(index);
    return null;
  }

  static actualizardetalle(int index, double? monto) {
    if (monto != null) {
      pagos[index].montoAplicado = monto;
    }
  }

  static double obtenerSubtotal() {
    if (pagos.length > 0) {
      double monto = pagos
          .map((e) => e.montoAplicado)
          .reduce((value, element) => value + element);
      if (monto != 0) {
        return monto;
      }
    }
    return 0;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

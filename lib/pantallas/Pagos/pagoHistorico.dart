import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:sigalogin/clases/formatos.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/modelos/pagodetalle.dart';
import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import 'dart:math' as math;
import '../../clases/factura.dart';
import '../buscar/buscarFacturasParaPagos.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:intl/intl.dart';

class MyPagosHistoricos extends StatefulWidget {
  String? customerCode;
  String? clienteName;
  MyPagosHistoricos(this.customerCode, this.clienteName, {super.key});

  @override
  State<MyPagosHistoricos> createState() =>
      _MyPagosHistoricosState(this.customerCode, this.clienteName);
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyPagosHistoricosState extends State<MyPagosHistoricos> {
  String? customerCode;
  String? clienteName;
  _MyPagosHistoricosState(this.customerCode, this.clienteName);
//   // Create a text controller and use it to retrieve the current value
//   // of the TextField.
//   final myController = TextEditingController();

  // This controller is connected to the text field
  late TextEditingController _controller;
  TextEditingController valordelpagoControler = TextEditingController();
  TextEditingController formadelpagoController = TextEditingController();
  TextEditingController bancodelpagoController = TextEditingController();
  TextEditingController numerodechequeController = TextEditingController();
  TextEditingController fechaChequeController = TextEditingController();
  TextEditingController fechaPagoController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  double? valordelpago = 0;
  List<TextEditingController> _controllers = [];

  List<PagoDetalle> facturas = [];
  List<PagoTemporal> facturaTemp = [];

  List<PagoTemporal> pagoList = [];

  final pago = <Pago>[];

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance
        .obtenerPagoDetallePorIdyCliente(10)
        .then((value) => {
              setState(() {
                value.forEach((element) {
                  pagoList.add(PagoTemporal(
                      compagni: element.compagni,
                      fechaFactura: DateTime.now().toIso8601String(),
                      fechaVencimiento: DateTime.now().toIso8601String(),
                      facturaId: element.facturaId,
                      id: element.id,
                      isDelete: element.isDelete,
                      montoAplicado: element.montoAplicado,
                      sincronizado: 0,
                      valorFactura: element.montoAplicado,
                      montoDeFacturaAlMomento:
                          element.montoDeFacturaAlMomento));
                  // facturas.add(element);
                });
              })
            });

    DatabaseHelper.instance.obtenerPagoPorIdyCliente(10).then((value) => {
          setState(() {
            value.forEach((element) {
              formadelpagoController.text = element.metodoDePago.toString();
              bancodelpagoController.text = element.banco.toString() != null
                  ? ""
                  : element.banco.toString();
              valordelpagoControler.text =
                  element.montoPagado.toStringAsFixed(2);
              numerodechequeController.text =
                  element.numeroDeCheque.toString() != null
                      ? ""
                      : element.numeroDeCheque.toString();
              fechaChequeController.text =
                  element.fechaDeCheque.toString() != null
                      ? ""
                      : element.fechaDeCheque.toString();
            });
          })
        });
  }

  Future _refresh() async {
    setState(() {
      facturaTemp = PagoTemporal.getDetalleFactura();

      //  FacturaDetalle.getFacturaDetalle();
      // NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
    });
  }

  static final GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // final _claveFormulario = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Pagos  Realizados  A : ' + this.clienteName.toString()),
      ),
      body: Form(
        key: _claveFormulario,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                controller: formadelpagoController,
                decoration: InputDecoration(
                  labelText: 'Forma de Pago    : 	',
                ),
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                controller: bancodelpagoController,
                decoration: InputDecoration(
                  labelText: 'Banco           : ',
                ),
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                controller: valordelpagoControler,
                decoration: InputDecoration(
                  labelText: 'Valor del pago',
                ),
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                controller: numerodechequeController,
                decoration: InputDecoration(labelText: 'Num. Cheque	'),
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                controller: fechaChequeController,
                decoration: InputDecoration(labelText: 'Fecha  Cheque	:'),
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                controller: fechaPagoController,
                decoration: InputDecoration(labelText: 'Fecha  Pago	:'),
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                controller: estadoController,
                decoration: InputDecoration(labelText: 'Estado	:'),
                readOnly: true,
                enabled: false,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: pagoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                        )
                      ],
                    )

                        // Row(children: [
                        //   Container(
                        //     width: 15,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     ),
                        //   ),
                        //   Container(
                        //     width: 250,
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Text(
                        //           'Num Factura		: ' + pagoList[index].facturaId,
                        //           style: TextStyle(
                        //               fontSize: 12, fontWeight: FontWeight.bold),
                        //         ),
                        //         Text(
                        //           'Fecha Emsión	 : ' + pagoList[index].facturaId,
                        //           style: TextStyle(fontSize: 14),
                        //         ),
                        //         Text(
                        //           'Fecha Vencimiento	: ' +
                        //               pagoList[index].facturaId,
                        //           style: TextStyle(
                        //             fontSize: 20,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ]
                        // ),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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

  static void limpiarDetalle() async {
    pagos.clear();
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

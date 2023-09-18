import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:sigalogin/clases/formatos.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/modelos/pagodetalle.dart';
import 'package:sigalogin/pantallas/Pagos/resumenDePago.dart';
import 'package:sigalogin/pantallas/reporte/Pagos/imprimirPagos.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import 'dart:math' as math;
import '../../clases/factura.dart';
import '../buscar/buscarFacturasParaPagos.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:intl/intl.dart';

import '../reporte/Pagos/printPagos.dart';

class MyCustomForm extends StatefulWidget {
  String? customerCode;
  String? clienteName;
  MyCustomForm(this.customerCode, this.clienteName, {super.key});

  @override
  State<MyCustomForm> createState() =>
      _MyCustomFormState(this.customerCode, this.clienteName);
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  String? customerCode;
  String? clienteName;
  _MyCustomFormState(this.customerCode, this.clienteName);
//   // Create a text controller and use it to retrieve the current value
//   // of the TextField.
//   final myController = TextEditingController();
  bool efectivo = false;
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

  // This controller is connected to the text field
  late TextEditingController _controller;
  TextEditingController valordelpagoControler = TextEditingController();
  TextEditingController formadelpagoController = TextEditingController();
  TextEditingController bancodelpagoController = TextEditingController();
  TextEditingController numerodechequeController = TextEditingController();
  TextEditingController fechaChequeController = TextEditingController();
  double? valordelpago = 0;
  List<TextEditingController> _controllers = [];

  List<PagoDetalle> facturas = [];
  List<PagoTemporal> facturaTemp = [];

  // Whether the textfield is read-only or not
  bool _isReadonly = false;

  // Whether the text field is disabled or enabled
  bool _isDisabled = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      facturaTemp = PagoTemporal.getDetalleFactura();
    });
    _controller = TextEditingController(text: 'Default Text');
  }

  Future _refresh() async {
    setState(() {
      facturaTemp = PagoTemporal.getDetalleFactura();
      valordelpago = Pago.obtenermontodelpago();
      //  FacturaDetalle.getFacturaDetalle();
      // NumeroPedido = DatabaseHelper.instance.getNextSalesOrders().toString();
    });
  }

  GlobalKey<FormState> _claveFormulario = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // final _claveFormulario = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Realizar Pagos  A : ' + this.clienteName.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Open shopping cart',
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyAppPrinter(),
                // builder: (context) => Cart(),
              ));

              // handle the press
            },
          ),
        ],
      ),
      body: Form(
        key: _claveFormulario,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null) {
                    return 'Debe de seleccionar una forma de Pago';
                  }
                },
                decoration: InputDecoration(labelText: 'Forma de Pago.'),
                // disabledHint: Text("-Seleccionar una forma de Pago"),
                value: _selectedValueFormaDePago,
                onChanged: (value) => {
                  // _verificaformadePago(value.toString())
                  if (value == 'Efectivo')
                    {
                      setState(() {
                        _selectedValueFormaDePago = value;
                        this.efectivo = true;
                        _isDisabled = true;
                      })
                    }
                  else
                    {
                      setState(() {
                        _selectedValueFormaDePago = value;
                        this.efectivo = false;
                        _isDisabled = false;
                      })
                    }
                },
                items: ListaFormaDepago.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (this.efectivo == false) {
                    if (value == null) {
                      return 'Este campo no puede estar vacio ';
                    }
                  }
                },
                decoration: InputDecoration(labelText: 'Banco.'),
                disabledHint: Text("-Seleccionar un banco"),
                value: _selectedValue,
                onChanged: _isDisabled
                    ? null
                    : (value) => {setState(() => _selectedValue = value)},
                items: ListaDeBancos.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
              TextFormField(
                validator: (value) {
                  if (value == "") {
                    return 'Este campo no puede estar vacio ';
                  }
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                controller: valordelpagoControler,
                decoration: InputDecoration(
                  labelText: 'Valor del pago	',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (this.efectivo == false) {
                    if (value == null) {
                      return 'Este campo no puede estar vacio ';
                    }
                  }
                },
                controller: formadelpagoController,
                decoration: InputDecoration(labelText: 'Num. Cheque	'),
                readOnly: _isReadonly,
                enabled: !_isDisabled,
              ),
              TextFormField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    print(
                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      fechaChequeController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                validator: (value) {
                  if (this.efectivo == false) {
                    if (value == null) {
                      return 'Este campo no puede estar vacio ';
                    }
                  }
                },
                controller: fechaChequeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Fecha Cheque'),
                readOnly: _isReadonly,
                enabled: !_isDisabled,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    child: Text('Buscar Factura'),
                    onPressed: () async {
                      if (_claveFormulario.currentState!.validate()) {
                        // double valordelPago =
                        //     double.parse(valordelpagoControler.text);
                        Pago.actualizarmontodelpago(
                            double.parse(valordelpagoControler.text));
                        Pago.actualizarpago(this.customerCode.toString(),
                            _selectedValueFormaDePago);
                        await showSearch(
                            context: context, delegate: BuscarFacturaEnPagos());
                        setState(() {
                          _refresh();
                        });
                      }
                    }),
              ),
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
                              width: 650,
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
                                          facturaTemp[index].facturaId,
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
                                          'Fecha Emisión	',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          facturaTemp[index]
                                              .fechaFactura
                                              .toString()
                                              .substring(1, 11),
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
                                          'Fecha Vencim.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          facturaTemp[index]
                                              .fechaVencimiento
                                              .toString()
                                              .substring(1, 11),
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
                                          NumberFormat.simpleCurrency().format(
                                              facturaTemp[index].valorFactura),
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
                                          NumberFormat.simpleCurrency().format(
                                              facturaTemp[index]
                                                  .valorPendiente),
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
                                          'valor pagó ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          child: TextField(
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false,
                                                    decimal: true),
                                            decoration: InputDecoration(
                                                labelText: NumberFormat
                                                        .simpleCurrency()
                                                    .format(facturaTemp[index]
                                                        .montoAplicado)),
                                            controller: _controllers[index],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        int? _index = index as int;
                                        double? monto = double.tryParse(
                                            _controllers[index].text);

                                        PagoTemporal.actualizardetalle(
                                            index, monto);
                                        PagoTemporal.actualizardetalle(
                                            index, monto);
                                        setState(() {
                                          _controllers[index].text = '';
                                          _refresh();
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 20,
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        int? _index = index as int;
                                        double? monto = double.tryParse(
                                            _controllers[index].text);

                                        PagoTemporal.eliminarpago(index);
                                        setState(() {
                                          _refresh();
                                        });
                                      },
                                    ),
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
    var resultado = pagos
        .where((element) => element.facturaId.contains(pago.facturaId))
        .toList();

    if (resultado.length == 0) {
      return pagos.add(pago);
    } else {
      return;
    }
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

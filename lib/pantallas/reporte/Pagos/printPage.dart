import 'package:flutter/material.dart';
import 'package:sigalogin/clases/api/facturaRecibo.dart';
import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

import 'package:flutter/services.dart';
import 'package:sigalogin/clases/global.dart';

class PrintPage extends StatefulWidget {
  final comprobanteDePago data;

  // final List<Map<String, dynamic>> data;
  PrintPage(this.data);

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'No existen dipositivos conectados';
  DateTime today = new DateTime.now();
  String dateSlug = "";
  @override
  void initState() {
    dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Conectado';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Desconectado';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Seleccionar impresora - Imprimir bolante de pago'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address ?? ''),
                              onTap: () async {
                                setState(() {
                                  _device = d;
                                });
                              },
                              trailing: _device != null &&
                                      _device!.address == d.address
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            ))
                        .toList(),
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            child: Text('Connectado'),
                            onPressed: _connected
                                ? null
                                : () async {
                                    if (_device != null &&
                                        _device!.address != null) {
                                      setState(() {
                                        tips = 'Conectando...';
                                      });
                                      await bluetoothPrint.connect(_device!);
                                    } else {
                                      setState(() {
                                        tips =
                                            'Por favor seleccione un dispositivo';
                                      });
                                      print(
                                          'Por favor seleccione un dipositivo');
                                    }
                                  },
                          ),
                          SizedBox(width: 10.0),
                          OutlinedButton(
                            child: Text('Desconectar'),
                            onPressed: _connected
                                ? () async {
                                    setState(() {
                                      tips = 'desconectando...';
                                    });
                                    await bluetoothPrint.disconnect();
                                  }
                                : null,
                          ),
                        ],
                      ),
                      Divider(),
                      OutlinedButton(
                        child: Text('Imprimir Factura'),
                        onPressed: _connected
                            ? () async {
                                Map<String, dynamic> config = Map();
                                config['width'] = 40;
                                config['height'] = 70;
                                config['gap'] = 2;
                                List<LineText> list = [];
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    x: 10,
                                    y: 10,
                                    content: 'SISTEMA SIGA, SRL',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: compagnia == 1
                                        ? 'RNC.: 1-30-0115-75'
                                        : '',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'TEL.: (809)236-8395',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '<< RECIBO DE INGRESO >>',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: ' ',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: ' ',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'NOMBRE.: ' +
                                        widget.data.clienteNombre.toString(),
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'RECIBO NO.: RCS0001',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'VALOR RD\$ ' +
                                        widget.data.montoPagado.toString(),
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'FECHA.:' + dateSlug,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'VEND.: ' + nombre_Usuario,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '===============================',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: ' ',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: ' ',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'DETALLE DE PAGO',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '===============================',
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'FACTURA     PAGADO    CONCEPTO',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '===============================',
                                    linefeed: 1));

                                for (var i = 0;
                                    i < widget.data.pagos.length;
                                    i++) {
                                  list.add(
                                    LineText(
                                      type: LineText.TYPE_TEXT,
                                      content: widget.data.pagos[i].facturaId
                                              .toString() +
                                          '    ' +
                                          widget.data.pagos[i].montoAplicado
                                              .toString() +
                                          '     ' +
                                          "SALDO",
                                      // 'FSV024943     8,544.00  SALDO',
                                      weight: 0,
                                      align: LineText.ALIGN_LEFT,
                                      linefeed: 1,
                                    ),
                                  );
                                }

                                // list.add(LineText(
                                //     type: LineText.TYPE_TEXT,
                                //     content: 'FSV024943     8,544.00  SALDO',
                                //     align: LineText.ALIGN_CENTER,
                                //     linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '================================',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '  ',
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '  ',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '  ____________________________',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'FIRMA',
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '    No es valido sin Firma',
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content:
                                        'CHEQUES O TRANFERENCIA DEBE SER CONFIRMADO CON EL BANCO',
                                    linefeed: 1));
                                list.add(LineText(linefeed: 1));

                                // ByteData data = await rootBundle
                                //     .load("assets/images/bluetooth_print.png");
                                // List<int> imageBytes = data.buffer.asUint8List(
                                //     data.offsetInBytes, data.lengthInBytes);
                                // String base64Image = base64Encode(imageBytes);
                                // list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));

                                await bluetoothPrint.printReceipt(config, list);
                              }
                            : null,
                      ),
                      // OutlinedButton(
                      //   child: Text('print label(tsc)'),
                      //   onPressed: _connected
                      //       ? () async {
                      //           Map<String, dynamic> config = Map();
                      //           config['width'] = 40; // 标签宽度，单位mm
                      //           config['height'] = 70; // 标签高度，单位mm
                      //           config['gap'] = 2; // 标签间隔，单位mm

                      //           // x、y坐标位置，单位dpi，1mm=8dpi
                      //           List<LineText> list = [];
                      //           list.add(LineText(
                      //               type: LineText.TYPE_TEXT,
                      //               x: 10,
                      //               y: 10,
                      //               content: 'A Title'));
                      //           list.add(LineText(
                      //               type: LineText.TYPE_TEXT,
                      //               x: 10,
                      //               y: 40,
                      //               content: 'this is content'));
                      //           list.add(LineText(
                      //               type: LineText.TYPE_QRCODE,
                      //               x: 10,
                      //               y: 70,
                      //               content: 'qrcode i\n'));
                      //           list.add(LineText(
                      //               type: LineText.TYPE_BARCODE,
                      //               x: 10,
                      //               y: 190,
                      //               content: 'qrcode i\n'));

                      //           // List<LineText> list1 = [];
                      //           // ByteData data = await rootBundle
                      //           //     .load("assets/images/guide3.png");
                      //           // List<int> imageBytes = data.buffer.asUint8List(
                      //           //     data.offsetInBytes, data.lengthInBytes);
                      //           // String base64Image = base64Encode(imageBytes);
                      //           // list1.add(LineText(
                      //           //   type: LineText.TYPE_IMAGE,
                      //           //   x: 10,
                      //           //   y: 10,
                      //           //   content: base64Image,
                      //           // ));

                      //           await bluetoothPrint.printLabel(config, list);
                      //           // await bluetoothPrint.printLabel(config, list1);
                      //         }
                      //       : null,
                      // ),
                      // OutlinedButton(
                      //   child: Text('print selftest'),
                      //   onPressed: _connected
                      //       ? () async {
                      //           await bluetoothPrint.printTest();
                      //         }
                      //       : null,
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data == true) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () =>
                      bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text('seleccionar impresora'),
//           backgroundColor: Colors.redAccent,
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   primary: Colors.blue, onPrimary: Colors.white),
//               onPressed: Platform.isAndroid
//                   ? () async {
//                       if (!await Permission.bluetoothConnect.isGranted) {
//                         await Permission.bluetoothConnect.request();
//                       }

//                       // FlutterBluePlus.instance.turnOff();
//                     }
//                   : null,
//               child: const Text('TURN OFF'),
//             )
//           ]),
//       body: _devices.isEmpty
//           ? Center(
//               child: Text(_devicesMsg ?? ''),
//             )
//           : ListView.builder(
//               itemCount: _devices.length,
//               itemBuilder: (c, i) {
//                 return ListTile(
//                   leading: Icon(Icons.print),
//                   title: Text(_devices[i].name!),
//                   subtitle: Text(_devices[i].address!),
//                   onTap: () {
//                     _startPrint(_devices[i]);
//                   },
//                 );
//               },
//             ),
//     );
//   }

//   Future<void> _startPrint(BluetoothDevice device) async {
//     if (device != null && device.address != null) {
//       await bluetoothPrint.connect(device);

//       var _connected;
//       bluetoothPrint.state.listen((state) {
//         print('cur device status: $state');

//         switch (state) {
//           case BluetoothPrint.CONNECTED:
//             setState(() {
//               _connected = true;
//             });
//             break;
//           case BluetoothPrint.DISCONNECTED:
//             setState(() {
//               print('Esta deconectado verifica');
//               _connected = false;
//             });
//             break;
//           default:
//             break;
//         }
//       });
//       Map<String, dynamic> config = Map();
//       config['width'] = 40;
//       config['height'] = 70;
//       config['gap'] = 2;
//       List<LineText> list = [];
//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           x: 10,
//           y: 10,
//           content: 'SISTEMA SIGA, SRL',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));
//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'RNC.: 1-30-0115-7',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'TEL.: (809)236-8395',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: '<< RECIBO DE INGRESO >>',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       list.add(LineText(type: LineText.TYPE_TEXT, content: ' ', linefeed: 1));

//       list.add(LineText(type: LineText.TYPE_TEXT, content: ' ', linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'NOMBRE.:  Real (Boca Chica )',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'RECIBO NO.: RCS0139778',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'VALOR RD\$ 8,544.00',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'FECHA.: 07/24/2023',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'VEND.: Gabriel Montero',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: '=============================',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: ' ',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));
//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: ' ',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'DETALLE DE PAGO',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'FACTURA     PAGADO    CONCEPTO',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       for (var i = 0; i < widget.data.pagos.length; i++) {
//         list.add(
//           LineText(
//             type: LineText.TYPE_TEXT,
//             content: widget.data.pagos[i].factura.toString() +
//                 '    ' +
//                 widget.data.pagos[i].montoPagado.toString() +
//                 '     ' +
//                 widget.data.pagos[i].estado.toString(),
//             // 'FSV024943     8,544.00  SALDO',
//             weight: 0,
//             align: LineText.ALIGN_LEFT,
//             linefeed: 1,
//           ),
//         );
//       }

//       // list.add(LineText(
//       //     type: LineText.TYPE_TEXT,
//       //     content: 'FSV024943     8,544.00  SALDO',
//       //     align: LineText.ALIGN_CENTER,
//       //     linefeed: 1));
//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: '=================================',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: '____________________________',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'FIRMA',
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'No es valido sin Firma',
//           linefeed: 1));

//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: 'CHEQUES O TRANFERENCIA DEBE SER CONFIRMADO CON EL BANCO',
//           linefeed: 1));

//       await bluetoothPrint.printLabel(config, list);

//       // for (var i = 0; i < widget.data.length; i++) {
//       //   list.add(
//       //     LineText(
//       //       type: LineText.TYPE_TEXT,
//       //       content: 'Hola',
//       //       weight: 0,
//       //       align: LineText.ALIGN_LEFT,
//       //       linefeed: 1,
//       //     ),
//       //   );

//       //   list.add(
//       //     LineText(
//       //       type: LineText.TYPE_TEXT,
//       //       content: "4545",
//       //       align: LineText.ALIGN_LEFT,
//       //       linefeed: 1,
//       //     ),
//       //   );
//       // }
//     }
//   }
// }

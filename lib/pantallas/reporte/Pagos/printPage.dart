import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  PrintPage(this.data);

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";
  final f = NumberFormat("\$###,###.00", "en_US");
  // final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {initPrinter()});
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen(
      (val) {
        if (!mounted) return;
        setState(() => {_devices = val});
        if (_devices.isEmpty)
          setState(() {
            _devicesMsg = "No existen dipositivos";
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('seleccionar impresora'),
        backgroundColor: Colors.redAccent,
      ),
      body: _devices.isEmpty
          ? Center(
              child: Text(_devicesMsg ?? ''),
            )
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(_devices[i].name!),
                  subtitle: Text(_devices[i].address!),
                  onTap: () {
                    _startPrint(_devices[i]);
                  },
                );
              },
            ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);

      var _connected;
      bluetoothPrint.state.listen((state) {
        print('cur device status: $state');

        switch (state) {
          case BluetoothPrint.CONNECTED:
            setState(() {
              _connected = true;
            });
            break;
          case BluetoothPrint.DISCONNECTED:
            setState(() {
              print('Esta deconectado verifica');
              _connected = false;
            });
            break;
          default:
            break;
        }
      });
      Map<String, dynamic> config = Map();
      config['width'] = 40; // 标签宽度，单位mm
      config['height'] = 70; // 标签高度，单位mm
      config['gap'] = 2; // 标签间隔，单位mm
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
          content: 'RNC.: 1-30-0115-7',
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

      list.add(LineText(type: LineText.TYPE_TEXT, content: ' ', linefeed: 1));

      list.add(LineText(type: LineText.TYPE_TEXT, content: ' ', linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'NOMBRE.:  Real (Boca Chica )',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'RECIBO NO.: RCS0139778',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'VALOR RD\$ 8,544.00',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'FECHA.: 07/24/2023',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'VEND.: Gabriel Montero',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '=============================',
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
          content: 'FACTURA     PAGADO    CONCEPTO',
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'FSV024943     8,544.00  SALDO',
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '=================================',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '____________________________',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'FIRMA',
          align: LineText.ALIGN_CENTER,
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'No es valido sin Firma',
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'CHEQUES O TRANFERENCIA DEBE SER CONFIRMADO CON EL BANCO',
          linefeed: 1));

      await bluetoothPrint.printLabel(config, list);

      // for (var i = 0; i < widget.data.length; i++) {
      //   list.add(
      //     LineText(
      //       type: LineText.TYPE_TEXT,
      //       content: 'Hola',
      //       weight: 0,
      //       align: LineText.ALIGN_LEFT,
      //       linefeed: 1,
      //     ),
      //   );

      //   list.add(
      //     LineText(
      //       type: LineText.TYPE_TEXT,
      //       content: "4545",
      //       align: LineText.ALIGN_LEFT,
      //       linefeed: 1,
      //     ),
      //   );
      // }
    }
  }
}

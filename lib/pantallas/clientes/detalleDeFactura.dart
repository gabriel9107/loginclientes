import 'package:sigalogin/clases/detalleFactura.dart';
import 'package:sigalogin/clases/modelos/facturaM.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:flutter/material.dart';

class DetalleDeFactura extends StatefulWidget {
  String? facturaId;
  DetalleDeFactura(this.facturaId);
  @override
  createState() => _DetalleDeFactura(this.facturaId);
}

class _DetalleDeFactura extends State<DetalleDeFactura> {
  String? facturaId;
  _DetalleDeFactura(this.facturaId);

  final detalle = <FacturaDetalle>[];
  late DetalleFacturaDataSource _detalleFacturaDataSource;

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance
        .obtenerDetalleDeFacturaPorFacturaId(facturaId!)
        .then((value) => {
              _detalleFacturaDataSource = DetalleFacturaDataSource(detalle),
              setState(() {
                value.forEach((element) {
                  detalle.add(FacturaDetalle(
                      compagnia: 0,
                      facturaId: element.facturaId,
                      isDelete: 1,
                      lineaNumero: element.lineaNumero,
                      montoLinea: element.montoLinea,
                      nombre: element.nombre,
                      precioVenta: element.precioVenta,
                      productoCodigo: element.productoCodigo,
                      qty: element.qty,
                      sincronizado: element.sincronizado,
                      id: element.id));
                });
                _detalleFacturaDataSource = DetalleFacturaDataSource(detalle);
              })
            })
        .catchError((error) {
      print(error);
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la factura : ' + this.facturaId.toString()),

        // backgroundColor: Color.fromARGB(255, 25, 28, 228),
      ),
      body: SfDataGrid(
        source: _detalleFacturaDataSource,
        columns: <GridColumn>[
          GridColumn(
              columnName: 'ID',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ID',
                  ))),
          GridColumn(
              width: 150,
              columnName: 'Codigo',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('Codigo'))),
          GridColumn(
              columnName: 'Articulo',
              width: 250,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('Articulo'))),
          GridColumn(
              columnName: 'Cantidad',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('Cantidad'))),
          GridColumn(
              columnName: 'Monto',
              width: 100,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('Monto'))),
          GridColumn(
              columnName: 'Monto total',
              width: 150,
              label: Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
                  child: Text('Monto total'))),
        ],
      ),
    ));
  }

  // List<FacturaDetalle> obtenerDetalle =
  //     DatabaseHelper.instance.getDetalles() as List<FacturaDetalle>;
}

//
class DetalleFacturaDataSource extends DataGridSource {
  DetalleFacturaDataSource(List<FacturaDetalle> detalle) {
    dataGridRows = detalle
        .map<DataGridRow>((dataGridRows) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'ID', value: dataGridRows.id),
              DataGridCell<String>(
                  columnName: 'Codigo', value: dataGridRows.productoCodigo),
              DataGridCell<String>(
                  columnName: 'Articulo', value: dataGridRows.nombre),
              DataGridCell<int>(
                  columnName: 'Cantidad', value: dataGridRows.qty),
              DataGridCell<double>(
                  columnName: 'Monto Articulo', value: dataGridRows.montoLinea),
              DataGridCell<double>(
                  columnName: 'Monto total', value: dataGridRows.precioVenta),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'ID' ||
                dataGridCell.columnName == 'Codigo')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

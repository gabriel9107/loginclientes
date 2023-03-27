import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/pagodetalle.dart';
import 'package:sigalogin/servicios/db_helper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MyPagosHistoricos extends StatefulWidget {
  int pagoId;

  MyPagosHistoricos(this.pagoId, {super.key});

  @override
  State<MyPagosHistoricos> createState() =>
      _MyPagosHistoricosState(this.pagoId);
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyPagosHistoricosState extends State<MyPagosHistoricos> {
  int pagoId;
  _MyPagosHistoricosState(this.pagoId);

  final detalle = <PagoDetalleLista>[];
  late DetalleFacturaDataSource _detalleFacturaDataSource;

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance
        .obtenerDetalleDePagoPorPagoId(pagoId)
        .then((value) => {
              _detalleFacturaDataSource = DetalleFacturaDataSource(detalle),
              setState(() {
                value.forEach((element) {
                  detalle.add(PagoDetalleLista(
                      fechaPago: element.fechaPago,
                      estado: element.estado,
                      facturaId: element.facturaId,
                      metodoDePago: element.metodoDePago,
                      montoPagado: element.montoPagado,
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
        title: Text('Detalle del Pago : ' + this.pagoId.toString()),

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
              columnName: 'FacturaId',
              width: 160,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('Numero de Factura'))),
          GridColumn(
              columnName: 'Metodo',
              width: 150,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('Metodo de Pago'))),
          GridColumn(
              columnName: 'Monto Pagado',
              width: 150,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('Monto Pagado'))),
          GridColumn(
              columnName: 'Estado',
              width: 150,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child: Text('Estado'))),
        ],
      ),
    ));
  }
}

class DetalleFacturaDataSource extends DataGridSource {
  DetalleFacturaDataSource(List<PagoDetalleLista> detalle) {
    dataGridRows = detalle
        .map<DataGridRow>((dataGridRows) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'ID', value: dataGridRows.id),
              DataGridCell<String>(
                  columnName: 'FacturaId', value: dataGridRows.facturaId),
              DataGridCell<String>(
                  columnName: 'Metodo', value: dataGridRows.metodoDePago),
              DataGridCell<double>(
                  columnName: 'MontoPagado', value: dataGridRows.montoPagado),
              DataGridCell<String>(
                  columnName: 'Estado', value: dataGridRows.estado),
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
        alignment: (dataGridCell.columnName == 'ID')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

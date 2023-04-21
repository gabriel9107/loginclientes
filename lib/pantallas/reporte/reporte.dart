import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class MyReporte extends StatefulWidget {
  @override
  _miReporte createState() => _miReporte();
}

class _miReporte extends State<MyReporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Generar Reporte'),
          onPressed: createExcel,
        ),
      ),
    );
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    // OpenFile.open(path);
  }
}

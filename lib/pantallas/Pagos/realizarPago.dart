import 'package:flutter/material.dart';

class RealizarPago extends StatefulWidget {
  @override
  _realizarPagoPageState createState() => _realizarPagoPageState();
}

class _realizarPagoPageState extends State<RealizarPago> {
  bool checkbox1 = true;
  bool checkbox2 = false;
  String gender = 'male';
  String dropdownValue = 'A';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Widgets'),
      ),
      // body:
    );
  }
}

import 'package:flutter/material.dart';

import '../buscar/buscarFacturasParaPagos.dart';

class RealizarPago extends StatefulWidget {
  @override
  _realizarPagoPageState createState() => _realizarPagoPageState();
}

class _realizarPagoPageState extends State<RealizarPago> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Realizar Pagos'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {
                showSearch(context: context, delegate: BuscarFacturaEnPagos())
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_form(), _list()],
          ),
          // body:
        ));
  }
}

_form() => Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Forma de Pago'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Entidad Bancaria	'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor del pago	'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Num. Cheque	'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Fecha Cheque'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Mobile'),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Submit'),
                // color: darkBlueColor,
                // textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

_list() => Text('list of contacts goes here');

import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/pantallas/clientes/listaClientes.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas%20copy.dart';
import 'package:sigalogin/servicios/PedidoDetalle_Servicio.dart';

import 'package:http/http.dart' as http;

import '../../clases/detalleFactura.dart';
import '../../clases/modelos/pagodetalle.dart';
import '../../servicios/db_helper.dart';
import '../NavigationDrawer.dart';

class cobroLista extends StatefulWidget {
  @override
  createState() => _ListaCobrosState();
}

class _ListaCobrosState extends State<cobroLista> {
  TextEditingController dateStartinput = TextEditingController();

  TextEditingController dateEndinput = TextEditingController();

  late DatabaseReference dbref;
  // late List<Client> Clients;
  int count = 0;

  @override
  void initState() {
    dateStartinput.text = "";
    dateEndinput.text = "";
    dbref = FirebaseDatabase.instance.ref().child('Pedidos');
    // Clients = Client.getClients();
    super.initState();
  }

  Widget build(BuildContext context) {
    // Clients.sort();
    return Scaffold(
        appBar: AppBar(
          title: Text('Reporte de Cobros'),

          // backgroundColor: Color.fromARGB(255, 25, 28, 228),

          actions: [
            IconButton(
                icon: Icon(Icons.filter_1),
                onPressed: () => {
                      // createExcel()
                    })
          ],
        ),
        drawer: navegacions(),
        body: SafeArea(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Text('Desde :'),
                ],
              ),
              SizedBox(
                  height: 20.0,
                  width: 200.0,
                  child: TextField(
                      controller:
                          dateStartinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "" //label text of field
                          ),
                      readOnly: true,
                      // when true user cannot edit text
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
                            dateStartinput.text =
                                formattedDate; //set foratted date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      })),
              Spacer(),
              const Text('Hasta :'),
              SizedBox(
                  height: 20.0,
                  width: 200.0,
                  child: TextField(
                      controller:
                          dateEndinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "" //label text of field
                          ),
                      readOnly: true, // when true user cannot edit text
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
                            dateEndinput.text =
                                formattedDate; //set foratted date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      })),
              Spacer(),
              ElevatedButton(child: Text('Filtrar'), onPressed: buscarPagos),
            ],
          ),
        ));
  }

  Future<void> buscarPagos() async {}
}

class ListPagos extends StatelessWidget {
  Icon ic = const Icon(Icons.abc);
  String? clientesId;
  ListPagos(this.ic, this.clientesId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PagoDetalleLista>>(
        future: DatabaseHelper.instance
            .obtenerDetalleDePagoPorCliente(this.clientesId.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<PagoDetalleLista>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Cargando...'));
          }
          return snapshot.data!.isEmpty
              ? Center(child: Text('No existen Pagos en el momento...'))
              : ListView(
                  children: snapshot.data!.map((pago) {
                    return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: pago.estado == 'Pendiente'
                                ? Colors.blue
                                : Colors.yellow,
                            child: Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                            ),
                          ),

                          title: Text('Numero de Pago : ' + pago.id.toString()),

                          subtitle: Text('Fecha del pago : ' +
                              DateFormat('dd-MM-yyy').format(pago.fechaPago)),
                          // subtitle: Text(
                          //     'Fecha del pago :' + pago.fechaPago.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Text('Factura : ' +
                                          pago.facturaId.toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Forma de Pago : ' +
                                          pago.metodoDePago.toString())
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Monto : ' +
                                          NumberFormat.simpleCurrency()
                                              .format(pago.montoPagado))
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 10,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ));
                  }).toList(),
                );
        });
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
          );
        },
      ),
    );
  }
}

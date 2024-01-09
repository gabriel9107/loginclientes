import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/pantallas/clientes/detalleDelCLiente.dart';
import 'package:sigalogin/pantallas/clientes/listaClientes.dart';

import '../../clases/customers.dart';

import '../../servicios/db_helper.dart';

// ignore: must_be_immutable
class NewClient extends StatelessWidget {
  //Titulo del App bar en caso de que se edite o que se agregue un nuevo registro.
  String AppBarTitle;

  NewClient(this.AppBarTitle);
  final customerCodeController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerDirController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final commentController = TextEditingController();
  final descuentoController = TextEditingController();
  String? selectedValue;
  // const NewClient({super.key});

  GlobalKey _loginNew_Cliente = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.AppBarTitle),
          actions: [
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (selectedValue != null) {
                    DatabaseHelper.instance.agregarNuevoCLiente(Cliente(
                        codigo: customerCodeController.text.toString().trim(),
                        codigoVendedor: usuario,
                        comentario: commentController.text,
                        compagnia: compagnia,
                        direccion: customerDirController.text,
                        nombre: customerNameController.text,
                        telefono1: phone1Controller.text,
                        telefono2: phone2Controller.text,
                        descuento: descuentoController.text,
                        sincronizado: 0,
                        activo: 0,
                        creadoEn: DateTime.now().toIso8601String()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetalleDelCliente(
                                customerCodeController.text,
                                customerNameController.text)));
                  }
                })
          ],
        ),
        body: Form(
          key: _loginNew_Cliente,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: customerCodeController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'RNC',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'No puede ser nulo';
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: customerNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nombre Cliente',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'No puede ser nulo';
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: customerDirController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Direccion',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'No puede ser nulo';
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: phone1Controller,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Telefono',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: phone2Controller,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Celular ',
                  ),
                ),
              ),
              DropdownButtonFormField(
                hint: Text('Descuento del cliente'),
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'No puede ser nulo';
                //   }
                // },

                elevation: 4,
                isDense: true,
                isExpanded: true,
                iconSize: 60.0,
                // onChanged: selectedValue,
                value: selectedValue,

                items: <String>['20', '25']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      child: Text(value), value: value);
                }).toList(),

                onChanged: (String? value) {
                  selectedValue = value;
                  // descuentoController.text = value as String;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Comentario',
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

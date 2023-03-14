import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.AppBarTitle),
          actions: [
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (descuentoController.text != "") {
                    DatabaseHelper.instance.agregarNuevoCLiente(Cliente(
                        codigo: int.parse(customerCodeController.text),
                        codigoVendedor: usuario,
                        comentario: commentController.text,
                        compagnia: compagnia,
                        direccion: customerDirController.text,
                        nombre: customerNameController.text,
                        telefono1: phone1Controller.text,
                        telefono2: phone2Controller.text,
                        descuento: descuentoController.text,
                        sincronizado: 1,
                        activo: 0,
                        creadoEn: DateTime.now().toIso8601String()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => clienteLista()));
                  }
                })
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: customerCodeController,
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
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Celular ',
                  ),
                ),
              ),

              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: DropdownButtonFormField(
                    hint: Text('Descuento del cliente'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'No puede ser nulo';
                      }
                    },
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
                      descuentoController.text = value as String;
                    },
                  )),
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
              // Padding(
              //   padding: EdgeInsets.only(top: 15.5, bottom: 15.5),
              //   child: Row(children: <Widget>[
              //     ElevatedButton(
              //       child: Text('Guardar'),
              //       onPressed: () async {
              //         DatabaseHelper.instance.agregarNuevoCLiente(Cliente(
              //             codigo: customerCodeController.text,
              //             codigoVendedor: usuario,
              //             comentario: commentController.text,
              //             compagnia: compagnia,
              //             direccion: customerDirController.text,
              //             nombre: customerNameController.text,
              //             telefono1: phone1Controller.text,
              //             telefono2: phone2Controller.text,
              //             descuento: descuentoController.text,
              //             sincronizado: 1,
              //             activo: 0,
              //             creadoEn: DateTime.now().toIso8601String()));

              //         // DatabaseHelpe

              //         // await DatabaseHelper.instance.Add(Customers(
              //         //     CustomerCode: customerCodeController.text,
              //         //     CustomerName: customerNameController.text,
              //         //     CustomerDir: customerDirController.text,
              //         //     Phone1: phone1Controller.text,
              //         //     Phone2: phone2Controller.text,
              //         //     Comment1: commentController.text,
              //         //     creadoEn: DateTime.now().toString(),
              //         //     creadoPor: usuario));

              //         // Navigator.push(context,
              //         //     MaterialPageRoute(builder: (context) => clienteLista()));
              //       },
              //       style: ElevatedButton.styleFrom(
              //           textStyle:
              //               TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              //     ),
              //     // ElevatedButton(
              //     //   child: Text('Cancelar'),
              //     //   onPressed: () {},
              //     //   style: ElevatedButton.styleFrom(
              //     //       textStyle:
              //     //           TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              //     // )
              //   ]),
              // ),
            ],
          ),
        ));
  }
} 
  // const MyCustomForm({super.key});
 
  

  // @override
//   // Widget build(BuildContext context) {
//   //   return 
    
    
    
//   }
// }

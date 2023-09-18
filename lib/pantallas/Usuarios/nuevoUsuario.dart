import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/usuario.dart';
import 'package:sigalogin/pantallas/Usuarios/listaUsuarios.dart';

import '../../servicios/db_helper.dart';

// ignore: must_be_immutable
class NuevoUsuario extends StatelessWidget {
  //Titulo del App bar en caso de que se edite o que se agregue un nuevo registro.
  // ignore: non_constant_identifier_names
  late String AppBarTitle;

  NuevoUsuario(this.AppBarTitle);
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usuarioController = TextEditingController();
  final claveController = TextEditingController();
  final activoController = TextEditingController();
  String? selectedValue;
  // ignore: non_constant_identifier_names
  bool? Activo;
  // const NewClient({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppBarTitle),
          actions: [
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (selectedValue != null) {
                    DatabaseHelper.instance.agregarUsuario(
                      Usuario(
                          activo: 1,
                          nombre: nombreController.text,
                          apellido: apellidoController.text,
                          usuarioNombre: usuarioController.text,
                          usuarioClave: usuarioController.text,
                          compania: compagnia,
                          sincronizado: 0),
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => listaUsuarios()));
                  }
                })
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: nombreController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nombre',
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
                  controller: apellidoController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Apellidos ',
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
                  controller: usuarioController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nombre de Usuario',
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
                  controller: claveController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Clave del Usuario',
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              //   child: CheckboxListTile( //checkbox positioned at left
              //       value: Activo,
              //       controlAffinity: ListTileControlAffinity.leading,
              //       onChanged: (bool? value) {
              //           setState(() {
              //              check3 = value;
              //           });
              //       },
              //       title: Text("Do you really want to learn Flutter?"),
              //     ),
              //   ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButtonFormField(
                  hint: Text('Compañia'),
                  // elevation: 4,
                  isDense: true,
                  isExpanded: true,
                  iconSize: 60.0,
                  value: selectedValue,
                  items: <String>['Siga', 'Siga New']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        child: Text(value), value: value);
                  }).toList(),
                  onChanged: (String? value) {
                    selectedValue = value;
                  },
                ),
              ),
              DropdownButtonFormField(
                hint: Text('Activo ?'),
                elevation: 4,
                isDense: true,
                isExpanded: true,
                iconSize: 60.0,
                value: selectedValue,
                items: <String>['Activo ', 'Inactivo']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      child: Text(value), value: value);
                }).toList(),
                onChanged: (String? value) {
                  selectedValue = value;
                },
              ),
            ],
          ),
        ));
  }
}

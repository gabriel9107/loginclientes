import 'package:flutter/material.dart';

import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/usuario.dart';
import 'package:sigalogin/pantallas/Usuarios/listaUsuarios.dart';
import 'package:sigalogin/ui/InputDecorations.dart';

import '../../servicios/db_helper.dart';

// ignore: must_be_immutable
class EditarUsuario extends StatefulWidget {
  Usuario usuario;

  EditarUsuario(this.usuario);

  @override
  State<EditarUsuario> createState() => _editUsuarioScreenState(usuario);
}

class _editUsuarioScreenState extends State<EditarUsuario> {
  Usuario usuario;
  _editUsuarioScreenState(this.usuario);

  String? selectedValue;

  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final usuarioController = TextEditingController();
  final claveController = TextEditingController();
  final activoController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool? Activo;
  // const NewClient({super.key});

  static final _formUsuarioEditKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nombreController.text = usuario.nombre.toString();
    apellidoController.text = usuario.apellido.toString();
    usuarioController.text = usuario.usuarioNombre.toString();
    claveController.text = usuario.usuarioClave.toString();

    // selectedValue = usuario.compania.toString();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Editar Usuario " + usuario.nombre + ' ' + usuario.apellido),
          actions: [
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (selectedValue != null) {
                    DatabaseHelper.instance.actualizarUsuario(
                      Usuario(
                          activo: selectedValue.toString() == "Activo" ? 0 : 1,
                          nombre: nombreController.text,
                          apellido: apellidoController.text,
                          usuarioNombre: usuarioController.text,
                          usuarioClave: claveController.text,
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
          key: _formUsuarioEditKey,
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
                  decoration: InputDecorations.authInputDecoration(
                      hinText: '********', labelText: 'Clave del usuario'),
                  validator: (value) {
                    return (value != null && value.length >= 6)
                        ? null
                        : 'La contraseña debe de ser de 6 caracteres';
                  },
                ),
              ),
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

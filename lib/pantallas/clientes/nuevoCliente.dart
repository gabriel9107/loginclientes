import 'package:flutter/material.dart';
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/pantallas/clientes/listaClientes.dart';
import 'package:sigalogin/servicios/db_helper.dart';

class EditarCliente extends StatefulWidget {
  Cliente clientes;

  EditarCliente(this.clientes);

  @override
  State<EditarCliente> createState() => _editClienteScreenState(clientes);
}

String? selectedValue;

class _editClienteScreenState extends State<EditarCliente> {
  Cliente _clientes;
  _editClienteScreenState(this._clientes);
  final customerCodeController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerDirController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final commentController = TextEditingController();
  final descuentoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customerCodeController.text = _clientes.codigo.toString();
    customerNameController.text = _clientes.nombre.toString();
    customerDirController.text = _clientes.direccion.toString();
    phone1Controller.text = _clientes.telefono1.toString();
    phone2Controller.text = _clientes.telefono2.toString();
    commentController.text = _clientes.comentario.toString();
    descuentoController.text = _clientes.descuento.toString();
    selectedValue = _clientes.descuento.toString() == ""
        ? '20'
        : _clientes.descuento.toString();
  }

  final List<String> items = [
    '20',
    '25',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Cliente update = Cliente(
                    id: _clientes.id,
                    comentario: commentController.text,
                    codigo: customerCodeController.text,
                    direccion: customerDirController.text,
                    nombre: customerNameController.text,
                    telefono1: phone1Controller.text,
                    telefono2: phone2Controller.text,
                    creadoEn: DateTime.now().toString(),
                    activo: 1,
                    codigoVendedor: usuario,
                    compagnia: compagnia,
                    sincronizado: 0);
                try {
                  DatabaseHelper.instance.update(update);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => clienteLista()));
                } catch (e) {
                  print('error al actualizar el registro ');
                }
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                    return 'No puede ser nulo';
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
                    return 'No puede ser nulo';
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
                    return 'No puede ser nulo';
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
                    validator: (value) {
                      return 'No puede ser nulo';
                    },
                    hint: Text('Descuento del cliente'),
                    elevation: 4,
                    isDense: true,
                    isExpanded: true,
                    iconSize: 60.0,
                    // onChanged: selectedValue,
                    value: selectedValue,
                    items: <String>['20', '30']
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
                  maxLines: 3,
                  controller: commentController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Comentario',
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

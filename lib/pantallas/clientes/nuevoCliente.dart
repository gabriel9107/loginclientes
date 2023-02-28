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

class _editClienteScreenState extends State<EditarCliente> {
  Cliente _clientes;
  _editClienteScreenState(this._clientes);
  final customerCodeController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerDirController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customerCodeController.text = _clientes.codigo.toString();
    customerNameController.text = _clientes.nombre.toString();
    customerDirController.text = _clientes.direccion.toString();
    phone1Controller.text = _clientes.telefono1.toString();
    phone2Controller.text = _clientes.telefono2.toString();
    commentController.text = _clientes.comentario.toString();
  }

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
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Descuento',
                      enabled: false),
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/customers.dart';
import 'package:sigalogin/servicios/db_helper.dart';

class EditarCliente extends StatefulWidget {
  Customers clientes;

  EditarCliente(this.clientes);

  @override
  State<EditarCliente> createState() => _editClienteScreenState(clientes);
}

class _editClienteScreenState extends State<EditarCliente> {
  Customers _clientes;
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
    customerCodeController.text = _clientes.CustomerCode.toString();
    customerNameController.text = _clientes.CustomerName.toString();
    customerDirController.text = _clientes.CustomerDir.toString();
    phone1Controller.text = _clientes.Phone1.toString();
    phone2Controller.text = _clientes.Phone2.toString();
    commentController.text = _clientes.Comment1.toString();
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
                Customers update = Customers(
                    id: _clientes.id,
                    Comment1: commentController.text,
                    CustomerCode: customerCodeController.text,
                    CustomerDir: customerDirController.text,
                    CustomerName: customerNameController.text,
                    Phone1: phone1Controller.text,
                    Phone2: phone2Controller.text);
                DatabaseHelper.instance.update(update);
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
                  ),
                ),
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
          )),
    );
  }
}

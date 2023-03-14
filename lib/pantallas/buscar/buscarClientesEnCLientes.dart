import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/pantallas/clientes/detalleDelCLiente.dart';
import 'package:sigalogin/pantallas/pedidos/pedidos.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/customers.dart';
import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';
import '../pedidos/PedidosVentas.dart';

class MySearchDelegateParaClientesEnClientes extends SearchDelegate {
  @override
  final textController = TextEditingController();

  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            }),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        //Boton para regresar atras
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Cliente> _listaClientes = [];

    Customers.getCustomers().then((value) {
      value.forEach((item) => _listaClientes.add(item));
    });

    _listaClientes = TodosLosClientes.cast<Cliente>().toList();

    List<Cliente> suggestions = _listaClientes.where((element) {
      final result = element.nombre.toString().toLowerCase() +
          element.codigo.toString().toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text('Cliente No.: ' + suggestion.codigo.toString()),
          subtitle: Text('Nombre  : ' + suggestion.nombre),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(
                                  suggestion.codigo.toString(),
                                  suggestion.nombre)));
                      // TodosLosClientes = [];
                    },
                    child: const Icon(Icons.add)),
              )
            ],
          ),

          // Icon(Icons.add),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalleDelCliente(
                        suggestion.codigo.toString(), suggestion.nombre)));

            // query = suggestion.nombre;
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/clientes.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
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
    List<Customers> _listaClientes = [];

    Customers.getCustomers().then((value) {
      if (value != null) value.forEach((item) => _listaClientes.add(item));
    });

    _listaClientes = TodosLosClientes.cast<Customers>().toList();

    List<Customers> suggestions = _listaClientes.where((element) {
      final result = element.CustomerName.toString().toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text('Cliente No.: ' + suggestion.CustomerCode),
          subtitle: Text('Nombre  : ' + suggestion.CustomerName),

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
                                  suggestion.CustomerCode.toString(),
                                  suggestion.CustomerName)));
                      TodosLosClientes = [];
                    },
                    child: const Icon(Icons.add)),
              )
            ],
          ),

          // Icon(Icons.add),
          onTap: () {
            query = suggestion.CustomerName;
          },
        );
      },
    );
  }
}

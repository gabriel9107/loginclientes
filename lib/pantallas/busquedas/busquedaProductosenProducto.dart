import 'package:flutter/material.dart';

import '../../clases/facturaDetalle.dart';

class MySearchDelegateParaProductos extends SearchDelegate {
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
    List<Productos> suggestions = Productos.getProductos().where((element) {
      final result = element.nombreProducto.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text('Nombre: ' + suggestion.descripcionProducto),
          subtitle: Text('Costo : ' + suggestion.precioProducto.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.production_quantity_limits)),
              Container(
                width: 100,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Cantidad'),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  onTap: () {
                    query = suggestion.nombreProducto;
                  },
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    int valor = int.parse(textController.text.toString());

                    if (valor != null) {
                      FacturaDetalle.addfacturaDetalle(FacturaDetalle(
                          facturaNumero: "1",
                          codigoProducto: suggestion.codigoProducto,
                          montoproducto: suggestion.precioProducto,
                          nombreProducto: suggestion.nombreProducto,
                          cantidadProducto:
                              int.parse(textController.text.toString())));
                      close(context, null);
                    }
                  },
                  child: Text('Agregar'),
                ),
              )
            ],
          ),
          onTap: () {
            query = suggestion.nombreProducto;
          },
        );
      },
    );
  }
}

class Productos {
  String codigoProducto;
  String nombreProducto;
  String descripcionProducto;
  double precioProducto;

  Productos(
      {required this.codigoProducto,
      required this.nombreProducto,
      required this.descripcionProducto,
      required this.precioProducto});

  static List<Productos> getProductos() {
    return <Productos>[
      Productos(
          codigoProducto: '160X14 ',
          nombreProducto: 'TVR ARO',
          descripcionProducto: 'TVR ARO 1.60 X 14 NIQUEL',
          precioProducto: 993.18),
      Productos(
          codigoProducto: '3AA-15631-00',
          nombreProducto: '31120-CG125 ',
          descripcionProducto: 'TVR CAMPO 8-BOB CG125 COMPL    ',
          precioProducto: 804.07)
    ];
  }
}
